clear

read -s "What is the folder name? " folderName

echo "Creating path if not exists"
if [ -d $folderName ]; then
  rm -fr $folderName
fi

read -s "What is the repository name? " repoName

echo "Cloning forlife-web repository"
gh repo clone $repoName $folderName

cd $folderName

echo "Installing composer and npm dependencies"
composer install && npm install

echo "Cleaning and optimizing application"
php artisan clear-compiled
php artisan optimize:clear
php artisan optimize

echo "Compiling npm assets and production"
npm run production

read -s "We will do a rsync deploy? [ Y / N ] >> " doDeploy

if [[ doDeploy == "Y" ]]; then

  read -s "What is the remote path to our deploy? >> " $remotePath

  echo "Starting RSync deploy"
  rsync -varzuP \
    --human-readable \
    --exclude '.env.example' \
    --exclude '.codeclimate.yml'
    --exclude 'docker-compose.yml' \
    --exclude '.styleci.yml' \
    --exclude '.editorconfig' \
    --exclude '*.code-workspace' \
    --exclude '.idea' \
    --exclude '.env.*' \
    --exclude '.git' \
    --exclude '.gitattributes' \
    --exclude '.github' \
    --exclude '.gitignore' \
    --exlude '.phpunit.*' \
    --exclude '*.sqlite' \
    --exclude '*.json' \
    --exclude '*.lock' \
    --exclude 'tests' \
    --exclude 'phpunit.xml' \
    --exclude 'node_modules' \
    --exclude 'webpack.mix.js' \
    ./* \
    $remotePath
    
fi
