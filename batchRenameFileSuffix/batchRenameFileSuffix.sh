#! /bin/bash 

oldsuffix="pdf"
newsuffix="mp4"

dir=$(eval pwd)

for file in $(ls ${dir} | grep ".${oldsuffix}$")
do
    name=$(ls ${file} | cut -d. -f 1)
    echo "${name}.${oldsuffix}"
    mv ${file} ${name}.${newsuffix}
done
echo "change ${oldsuffix} to ${newsuffix} successful."
