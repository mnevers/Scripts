/// <summary>
/// CurrencyManager.cs
/// Matthew Nevers
/// 7/12/17
/// 
/// This script will be used to add and remove currency between bank and player inventory.
/// </summary>
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Devdog.General.UI;
using Devdog.InventoryPro;

public class CurrencyManager : MonoBehaviour {
	public Button startButton; //ref to bank cur button
	public Button cancelButton; //ref to cancel button
	public Button withButton; //withdraw ref
	public Button depButton; //deposit ref
	private float gold;
	private float silver;
	private float copper;
	public UIWindow uiw; //ui win ref
	public BankUI bui;
	public InventoryUI iui;
	public InputField[] iText;

	void Start(){
		//listeners setup
		startButton.onClick.AddListener(StartClick);
		cancelButton.onClick.AddListener (CancelClick);
		withButton.onClick.AddListener (WithdrawClick);
		depButton.onClick.AddListener (DepositClick);
	}

	void Update(){
		//Makes the currency values zero if they are "" so we don't get errors
		//with RemoveCurrency in other spots of script
		if (iText[2].text == "")
			iText[2].text = "0";
		if (iText[1].text == "")
			iText[1].text = "0";
		if (iText[0].text == "")
			iText[0].text = "0";
	}

	//On Start and Click Funtion call brodcast message saying 
	//its showing or not so we know if we can cast spells
	void StartClick(){
		uiw.Show ();
	}

	void CancelClick(){
		uiw.Hide ();
	}

	void WithdrawClick(){
		bool c0;
		bool c1;
		bool c2;

		gold = float.Parse(iText[2].text);
		silver = float.Parse(iText[1].text);
		copper = float.Parse(iText[0].text);

		c0 = bui.RemoveCurrency (0, copper, true);
		c1 = bui.RemoveCurrency (1, silver, true);
		c2 = bui.RemoveCurrency (2, gold, true);

		if (c0 && c1 && c2) {
			iui.AddCurrency (0, copper);
			iui.AddCurrency (1, silver);
			iui.AddCurrency (2, gold);
		} 

		if (c0) {
			if (!c1 || !c2) {
				bui.AddCurrency (0, copper);
			}
		}

		if (c1) {
			if (!c0 || !c2) {
				bui.AddCurrency (1, silver);
			}
		}

		if (c2) {
			if (!c0 || !c1) {
				bui.AddCurrency (2, gold);
			}
		}

		if (c0 && c1 && c2) {
			uiw.Hide ();
			iText [2].text = "0";
			iText [1].text = "0";
			iText [0].text = "0";
		}
	}

	void DepositClick(){
		bool c0;
		bool c1;
		bool c2;

		gold = float.Parse(iText[2].text);
		silver = float.Parse(iText[1].text);
		copper = float.Parse(iText[0].text);

		c0 = iui.RemoveCurrency (0, copper, true);
		c1 = iui.RemoveCurrency (1, silver, true);
		c2 = iui.RemoveCurrency (2, gold, true);

		if (c0 && c1 && c2) {
			bui.AddCurrency (0, copper);
			bui.AddCurrency (1, silver);
			bui.AddCurrency (2, gold);
		} 

		if (c0) {
			if (!c1 || !c2) {
				iui.AddCurrency (0, copper);
			}
		}

		if (c1) {
			if (!c0 || !c2) {
				iui.AddCurrency (1, silver);
			}
		}

		if (c2) {
			if (!c0 || !c1) {
				iui.AddCurrency (2, gold);
			}
		}

		if (c0 && c1 && c2) {
			uiw.Hide ();
			iText [2].text = "0";
			iText [1].text = "0";
			iText [0].text = "0";
		}
	}
		
}