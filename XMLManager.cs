/// <summary>
/// XMLManager.cs
/// 1/21/18
/// Matthew Nevers
/// 
/// XMLManager.cs serializes large amounts of data to xml spreadsheets. For easy viewing and processing during and after Run-time.
/// The rest of serialization occurs through Unity's PlayerPrefs in the registry. with headers of 1, 2 or 3 according to current save.
/// </summary>
using System.Collections.Generic;
using UnityEngine;
using System.Xml;
using System.Xml.Serialization;
using System.IO;    //file managment
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class XMLManager : MonoBehaviour {
    public static XMLManager ins; //Static instance made to this

    private int currentSave;
    private string sceneName;
    public GameObject aiParent;
    public Emerald_AI[] ais;
    private bool quitting = false;
    private Image loadOverlay;
    private float loadTimer = 0f;

    public PlayerHealth ph;    
    public MobDatabase mobDB;
    public PlayerEntry playerData;
    public SpellSlotEntry spellSlotData;

    void Awake() {
        ins = this;
        currentSave = PlayerPrefs.GetInt("CurrentSave", 1);
        loadOverlay = GameObject.FindGameObjectWithTag("LoadOverlay").GetComponent<Image>();
        Load();
    }

    private void OnEnable() {
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnDisable() {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void Update() {
        if(loadTimer > 0) {
            loadTimer -= Time.deltaTime;

            if(loadTimer <= 0) {
                loadTimer = 0f;

                loadOverlay.enabled = false;
            }
        }
    }

    void OnSceneLoaded(Scene scene, LoadSceneMode temp) {
        if (scene.name != "Test")
            loadTimer = 1f;

        aiParent = GameObject.FindGameObjectWithTag("AIParent");

        if (aiParent != null) {
            ais = aiParent.GetComponentsInChildren<Emerald_AI>();
        }

        sceneName = scene.name;

        LoadMobs(); 
    }

    private void OnApplicationQuit() {
        quitting = true;
       // Save(); //Keep me uncommented for offical builds
    }

    public void Save() {
        PlayerPrefs.SetString(currentSave + "SceneToLoad", sceneName);

        SavePlayer(); //finished

        if(!quitting) //this is because devdog already has applicationquit functionality
            Messenger.Broadcast("Save");//Only used by PlayerPrefs //Nothing below this line.
    }

    public void Load() {
        if (ph == null)
            ph = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerHealth>();

        LoadSpellSlots(); 
        LoadPlayer();
    }

    public void SavePlayer() {
        ph.SetInfo();
        XmlSerializer serializer = new XmlSerializer(typeof(PlayerEntry));
        FileStream stream = new FileStream(Application.dataPath + "/StreamingAssets/" + currentSave + "/playerData.xml", FileMode.Create);
        serializer.Serialize(stream, playerData);
        stream.Close();
    }

    public void LoadPlayer() {
        if (System.IO.File.Exists(Application.dataPath + "/StreamingAssets/" + currentSave + "/playerData.xml")) {
            XmlSerializer serializer = new XmlSerializer(typeof(PlayerEntry));
            FileStream stream = new FileStream(Application.dataPath + "/StreamingAssets/" + currentSave + "/playerData.xml", FileMode.Open);
            playerData = serializer.Deserialize(stream) as PlayerEntry;
            stream.Close();
        }
    }

[System.Serializable]
public class PlayerEntry {
    public string playerName;
    public int curLvl;
    public int curXP;
    public int attPoints;
    public float currentHp;
    public float currentMp;
    public float currentSp;
    public int str;
    public int intel;
    public int consti;
    public Vector3 pos;
    public float rotY;
    public int[] affinities = new int[9];
}
