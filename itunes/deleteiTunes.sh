set question to display dialog "Delete iTtunes?" buttons {"Yes", "No"} default button 1
set answer to button returned of question
if answer is equal to "Yes" then
    do shell script "rm -rf /Applications/iTunes.app" with administrator privileges
    display dialog "iTunes was deleted" buttons {"Ok"}
    set theDMG to choose file with prompt "Please select iTunes 12.6 dmg file:" of type {"dmg"}
    do shell script "hdiutil mount " & quoted form of POSIX path of theDMG
    do shell script "pkgutil --expand /Volumes/iTunes/Install\\ iTunes.pkg ~/tmp"
    do shell script "sed -i '' 's/18A1/14F2511/g' ~/tmp/Distribution"
    do shell script "sed -i '' 's/gt/lt/g' ~/tmp/Distribution"
    do shell script "pkgutil --flatten ~/tmp ~/Desktop/iTunes.pkg"
    do shell script "hdiutil unmount /Volumes/iTunes/"
    do shell script "rm -rf ~/tmp"
end if
if answer is equal to "No" then
    display dialog "iTunes was not deleted" buttons {"Ok"}
    return
end if

set question to display dialog "Install iTtunes?" buttons {"Yes", "No"} default button 1
set answer to button returned of question
if answer is equal to "Yes" then
    do shell script "open ~/Desktop/iTunes.pkg"
    return
end if
if answer is equal to "No" then
    display dialog "Modified iTunes.pkg saved on desktop" buttons {"Ok"}
    return
end if