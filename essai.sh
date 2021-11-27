#!/bin/bash

install_packet_manager () {
    sudo pacman -Sy --noconfirm base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
}
install_oh_my_zsh () {
    echo "Setting up zsh..."
    yay -S --noconfirm zsh
    chsh -s /bin/zsh
}

install_dev_dependencies () {
    yay -Sy --noconfirm slack code npm git-cola
    pip install pytest
}

install_vroomly_dependencies () {
    yay -Sy --noconfirm nodejs-lts-fermium lib32-libjpeg-turbo zlib libwebp postgresql imagemagick libwebp memcached python-pip python-setuptools python-wheel python-cffi cairomm pango gdk-pixbuf2 libffi shared-mime-info gdal ansible redis yarn git-lfs poetry
}
generate_ssh_key () {
    ssh-keygen -t ed25519 -C devmartinjordan@gmail.com
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
}
git_clone_docauto () {
    if test -d ~/docauto; then
        echo "Le dossier docauto existe déjà..."
    else
        git clone git@github.com:vroomly/docauto.git
    fi
}
install_git_lfs () {
    cd docauto
    git lfs install
    cd ~/
}
initiate_docauto_database () {
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sudo -u postgres createdb docauto
    sudo -u postgres createuser -s $USERNAME
}

test_exist_key () {
    if test -f ~/.ssh/id_rsa.pub && test -f ~/.ssh/id_ed25519.pub; then
        default_response="o"
        read -e -p "une clé SSH existe déjà, souhaitez-vous l'utiliser pour GitHub ? (O/n): " confirm
        default_response="${confirm:-$default_response}"
        if [[ $default_response == [oO] ]]; then
            cat ~/.ssh/id_ed25519.pub
            echo "Copié votre clé et ajouté la à vos clés SSH dans GitHub: https://github.com/settings/keys"
        fi
    else
        generate_ssh_key
    fi
}

install_poetry () {
    poetry config virtualenvs.in-project true
}
setup_virtualenv () {
    python -m venv .venv
    source .venv/bin/activate
}
setup_env_file_docauto () {
    cd docauto
    cp .env.template .env
}
poetry_genjs_npm_collectstatic_install () {
    cd docauto
    source .venv/bin/activate
    poetry install
    python manage.py genjs
    yarn
    python manage.py collectstatic --noinput
    yarn build
    python manage.py collectstatic --noinput
}

install_redis () {
    sudo systemctl restart redis.service
}
install_mailhog () {
    echo "setting up MailHog"
    get "https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64"
}

#install_packet_manager
install_oh_my_zsh
#install_dev_dependencies
#install_vroomly_dependencies
#test_exist_key
#git_clone_docauto
#install_git_lfs
#create_docauto_database
#install_poetry
#setup_virtualenv
#setup_env_file_docauto
#poetry_genjs_npm_collectstatic_install
#install_redis
#install_mailhog
