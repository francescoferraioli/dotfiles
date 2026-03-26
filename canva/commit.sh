git stash push -u -k
git checkout master
git pull
git stash pop
git add .
git commit -m "$1"
git push
git checkout ff-canva
git fmar
git push