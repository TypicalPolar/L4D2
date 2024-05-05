# Setup L4D2 Dedicated Server by TypicalPolar

# Run as the user normally used to operate the server. This shouldn't be run as the root
# account. While you shouldn't, the user can be apart of sudoers to simply things.

# When prompted for credentials, use an account that is apart of sudoers.

# General Parameters
l4d2_installation_dir="$(pwd)/l4d2"

# Parameters for Script Generation
server_ip=$(dig @resolver4.opendns.com myip.opendns.com +short) # Gathers the WAN IP of current workstation
server_cfg="server.cfg"
game_map="c1m4_atrium"
extra_parameters="-tickrate 100"

# Installing Dependencies
sudo apt install -y wget screen lib32gcc-s1
sudo add-apt-repository -y multiverse
sudo dpkg --add-architecture i386
sudo apt update

# Installing SteamCMD and Accepting EULA
echo steam steam/question select "I AGREE" | sudo debconf-set-selections
echo steam steam/license note '' | sudo debconf-set-selections
sudo apt install -y steamcmd

# Installing Left 4 Dead 2 Dedicated as Local User
mkdir $l4d2_installation_dir
steamcmd +force_install_dir $l4d2_installation_dir +login anonymous +app_update 222860 validate +quit

# Creating Start File
cat <<EOF > start_l4d2.sh
 ./l4d2/srcds_run -console -game left4dead2 -port 27015 +hostip $server_ip +map $game_map +exec $server_cfg $extra_parameters
EOF