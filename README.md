# Ezored

```
export PATH=${HOME}/.local/bin:$PATH

PATH=/home/ivan/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

# Configure

```
git clone https://github.com/ezored/ezored
cd ezored
pip install conan --upgrade
conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
pip install -r requirements.txt
python make.py conan setup
conan profile update settings.compiler.libcxx=libstdc++11 default
python make.py gluecode setup
```

# Linux app
```
cd host/ezored
python make.py target linux prepare
python make.py target linux build
```


