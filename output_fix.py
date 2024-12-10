#Removes excess whitespace from files 
import argparse

def main():
    parser = argparse.ArgumentParser(prog = "Questa Output Fix")
    parser.add_argument('--input',type=str,help="Filename/Path of the Input File")
    args = parser.parse_args()
    inFile = open(args.input, "r")
    outFile = open(args.input[0:(len(args.input) - 4)] + "_fixed.txt", "w")
    for line in inFile:
        newLine = line.replace(" ", "", 99)
        newLine = newLine.replace("\n", "")
        outFile.write(newLine)
    
main()