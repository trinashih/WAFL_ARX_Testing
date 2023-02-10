#!/bin/bash
# CMU/CMS/SRVR/Sales
# Trina Shih 02/09/2023
#
# SSVM AMD Devhub #57203
#

#Variables
Core="0"
Die="1"
Iterations="50"

# Initialize the array to store the random numbers
declare -a rand_numbers

function show_help {
  echo "Usage: $0 [-h] [-c <Core Number>] [-d <Die Number>] [-i <Iterations>]"
  echo "Options:"
  echo "  -h                Show this help message"
  echo "  -c <Core Number>  Default is 0, can be 0..96.."
  echo "  -d <Die Number >  Default is 1, can be 0,1 or more, if you have AMD GPUs"
  echo "  -i <Iterations >  Default is 50"
  exit 0
}

isroot() {
   [ `id | sed 's/uid=\([0-9]*\)(.*/\1/'` -eq 0 ] && return
   echo "Please get root privilege first"; exit 1
}



isroot
while getopts "hc:d:i:" opt; do
  case $opt in
    h)
      show_help
      ;;
    c)
      Core=$OPTARG
      #echo "Core=$CoreFile"
      ;;
    d)
      Die=$OPTARG
      #echo "Die=$Die"
      ;;
    i)
      Iterations=$OPTARG	    
      #echo "Iterations=$Iterations"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "Show Core=$Core, Die=$Die, Iterations=$Iterations"

# Generate the random numbers, each iteration requires 5 random numbers.
echo "Generate enough random numbers..."
temp=$(echo "$Iterations * 5" | bc)
#echo $temp
lower_bound=268435455  #0x0fffffff
upper_bound=4294967295 #0xffffffff
for ((i=1; i<=$temp; i++)); do
  rand_decimal=$((RANDOM * (upper_bound - lower_bound + 1) / 32767 + lower_bound))	
  # Convert the decimal number to hexadecimal
  #rand_hex=$(printf "%x\n" $rand_decimal)
  rand_numbers[i]=$(printf "%x\n" $rand_decimal)
  #rand_numbers[i]=$(printf "%X\n" $(od -A n -t u4 -N 4 /dev/urandom | awk '{print $1}'))  <--that may generate a number smaller than lower_bound.
done

echo "Testing START..."

k=1
#echo "k=$k"
for ((j=1; j<=$Iterations; j++)); do
  echo "============================Iteration: $j==========================="
  Val=${rand_numbers[$k]}
  echo "write value=$Val"
  sudo numactl -C $Core ARX write -d $Die -n IOHC -r NBCFG_SCRATCH_0 -v 0x${rand_numbers[$k]} -i _nbio0_aliasSMN
  #get results and doing compariasion. 
  getoutput=`sudo numactl -C $Core ARX read -d $Die -n IOHC -r NBCFG_SCRATCH_0 -i _nbio0_aliasSMN | grep -i _aliasSMN`
  getnumber=${getoutput: -8}
  #capitalized=$(echo "$getnumber" | tr '[:lower:]' '[:upper:]')
  #echo "read value=$capitalized"
  echo "read value=$getnumber"
  #if [ "$Val" = "$capitalized" ]; then
  if [ "$Val" = "$getnumber" ]; then
	  echo "Pass"
  else
	  echo "Fail"
	  exit 2
  fi
  k=$((k+1))

  Val=${rand_numbers[$k]}
  echo "write value=$Val"
  sudo numactl -C $Core ARX write -d $Die -n IOHC -r NBCFG_SCRATCH_1 -v 0x${rand_numbers[$k]} -i _nbio0_aliasSMN
  #get results and doing compariasion. 
  getoutput=`sudo numactl -C $Core ARX read -d $Die -n IOHC -r NBCFG_SCRATCH_1 -i _nbio0_aliasSMN | grep -i _aliasSMN`
  getnumber=${getoutput: -8}
  #capitalized=$(echo "$getnumber" | tr '[:lower:]' '[:upper:]')
  #echo "read value=$capitalized"
  echo "read value=$getnumber"
  #if [ "$Val" = "$capitalized" ]; then
  if [ "$Val" = "$getnumber" ]; then
	  echo "Pass"
  else
	  echo "Fail"
	  exit 2
  fi
  k=$((k+1))

  Val=${rand_numbers[$k]}
  echo "write value=$Val"
  sudo numactl -C $Core ARX write -d $Die -n IOHC -r NBCFG_SCRATCH_2 -v 0x${rand_numbers[$k]} -i _nbio0_aliasSMN
  #get results and doing compariasion. 
  getoutput=`sudo numactl -C $Core ARX read -d $Die -n IOHC -r NBCFG_SCRATCH_2 -i _nbio0_aliasSMN | grep -i _aliasSMN`
  getnumber=${getoutput: -8}
  #capitalized=$(echo "$getnumber" | tr '[:lower:]' '[:upper:]')
  #echo "read value=$capitalized"
  echo "read value=$getnumber"
  #if [ "$Val" = "$capitalized" ]; then
  if [ "$Val" = "$getnumber" ]; then
	  echo "Pass"
  else
	  echo "Fail"
	  exit 2
  fi
  k=$((k+1))

  Val=${rand_numbers[$k]}
  echo "write value=$Val"
  sudo numactl -C $Core ARX write -d $Die -n IOHC -r NBCFG_SCRATCH_3 -v 0x${rand_numbers[$k]} -i _nbio0_aliasSMN
  #get results and doing compariasion. 
  getoutput=`sudo numactl -C $Core ARX read -d $Die -n IOHC -r NBCFG_SCRATCH_3 -i _nbio0_aliasSMN | grep -i _aliasSMN`
  getnumber=${getoutput: -8}
  #capitalized=$(echo "$getnumber" | tr '[:lower:]' '[:upper:]')
  #echo "read value=$capitalized"
  echo "read value=$getnumber"
  #if [ "$Val" = "$capitalized" ]; then
  if [ "$Val" = "$getnumber" ]; then
	  echo "Pass"
  else
	  echo "Fail"
	  exit 2
  fi
  k=$((k+1))

  Val=${rand_numbers[$k]}
  echo "write value=$Val"
  sudo numactl -C $Core ARX write -d $Die -n IOHC -r NBCFG_SCRATCH_4 -v 0x${rand_numbers[$k]} -i _nbio0_aliasSMN
  #get results and doing compariasion. 
  getoutput=`sudo numactl -C $Core ARX read -d $Die -n IOHC -r NBCFG_SCRATCH_4 -i _nbio0_aliasSMN | grep -i _aliasSMN`
  getnumber=${getoutput: -8}
  #capitalized=$(echo "$getnumber" | tr '[:lower:]' '[:upper:]')
  #echo "read value=$capitalized"
  echo "read value=$getnumber"
  #if [ "$Val" = "$capitalized" ]; then
  if [ "$Val" = "$getnumber" ]; then
	  echo "Pass"
  else
	  echo "Fail"
	  exit 2
  fi
  k=$((k+1))


done




#Output the array
echo "All the numbers we generated:"
echo "${rand_numbers[@]}"

