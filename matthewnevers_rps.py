#Matthew Nevers
#Simple Rock Paper, Scissors program written in perl.
#10/2/17
#matthewnevers_rps.py reads in an arbitrary number.  The first argument (rounds)
#is used as the number of rounds if the user wants to run the program more expediently
#To execute the program simply enter python matthewnevers_rps.py (# of rounds)
#if no argument is given the program will ask at run time for a #
import random
import argparse

#Creating a parser to check for positional and optional arguments
parser = argparse.ArgumentParser(description='The program plays a game of Rock Paper Scissors and writes the results to the console and a text file named results.txt')
parser.add_argument('rounds', help='Rounds to play', nargs='?', type=int)
args = parser.parse_args()

plays = ['Empty', 'Rock', 'Paper', 'Scissors']
playerScore = 0
cpuScore = 0

print ("***Rock Paper Scissors***");

if(args.rounds == None):
    args.rounds = int(input('How many rounds do you want to play?: '))

while(args.rounds < 1):
    args.rounds = int(input('Please enter a valid # of rounds: '))

#Is called upon as often as need per how many rounds there are to play
def PlayRound():
    #Display score then ask for rock paper or scissors (1,2,3 respectively)
    global playerScore
    global cpuScore
    print ('\nScore: ', playerScore,' (You) - ', cpuScore, ' (CPU)')
    play = int(input('1 - Rock, 2 - Paper, or 3 - Scissors?: '))
    cpuPlay = random.randint(1, 3)

    while (play > 3 or play < 1):
        play = int(input('Please enter a valid play #: '))

    if (play == cpuPlay):
        print ('You both played', plays[play],'! Go again.')
        return

    win = CheckRound(play, cpuPlay)

    if(win == True):
        print('CPU played', plays[cpuPlay],'you won!')
        playerScore += 1
    else:
        print('CPU played', plays[cpuPlay], 'you lost!')
        cpuScore += 1

    args.rounds -= 1

#A series of simple if statements that can be called on to determine winner
#returns the result of a round by a bool (true = player win, false = cpu win)
def CheckRound(play1, play2):
    if (play1 == play2 + 1):
        win = True
    elif(play1 == play2 - 1):
        win = False
    elif(play1 == play2 + 2):
        win = False
    elif (play1 == play2 - 2):
        win = True

    return (win)

#Displays results to console
def DisplayResult():
    print ('\n-----------------------------------------')
    print ('GAME OVER - Results:')
    print ('-----------------------------------------')
    print('Score: ', playerScore, ' (You) - ', cpuScore, ' (CPU)')

    if (playerScore > cpuScore):
        print ('You are the winner!')
    elif (playerScore < cpuScore):
        print ('CPU is the winner!')
    else:
        print ("It's a tie!")

#Saves result by appending a file named results.txt in same dir
def SaveResult():
    print('\nSaving Results...')
    file = open('results.txt', 'a');
    file.write("Player: %s \n" % (playerScore))
    file.write("CPU: %s \n\n" % (cpuScore))
    file.close()
    print('Results saved to results.txt!')

while (args.rounds > 0):
    PlayRound()

DisplayResult()
SaveResult()