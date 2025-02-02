#!/bin/bash
set -e
# Atualizar e instalar dependências básicas
sudo apt update
sudo apt install -y build-essential cmake git pkg-config libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev python3-dev python3-numpy libtbb2 libtbb-dev

# Instalar o OpenCV diretamente dos repositórios do Ubuntu
sudo apt install -y libopencv-dev python3-opencv libomp-dev

# Instalando dependências do OpenVINO
echo "Instalando dependências..."
sudo apt install -y lsb-release wget sudo cmake build-essential
sudo apt install -y python3 python3-pip python3-dev
sudo apt install -y libopencv-dev libprotobuf-dev protobuf-compiler
sudo apt install -y libssl-dev
sudo apt install -y libcurl4-openssl-dev
sudo apt install -y git

# Baixando o OpenVINO
echo "Baixando o OpenVINO..."
OPENVINO_VERSION="ubuntu20_2024.0.0.14509.34caeefd078"
OPENVINO_FILE="l_openvino_toolkit_${OPENVINO_VERSION}_x86_64.tgz"
OPENVINO_URL="https://storage.openvinotoolkit.org/repositories/openvino/packages/2024.0/linux/$OPENVINO_FILE"
OPENVINO_DIR="/content/l_openvino_toolkit_${OPENVINO_VERSION}_x86_64"

wget -O "$OPENVINO_FILE" "$OPENVINO_URL"

# Extraindo o arquivo
tar -xvzf "$OPENVINO_FILE"

# Instalando OpenVINO
sudo "./l_openvino_toolkit_${OPENVINO_VERSION}_x86_64/install_dependencies/install_openvino_dependencies.sh"

# Configurando variáveis de ambiente do OpenVINO
echo "Configurando OpenVINO..."
source "./l_openvino_toolkit_${OPENVINO_VERSION}_x86_64/setupvars.sh"

# Limpando arquivos temporários
cd ..
rm -rf "$OPENVINO_FILE" "l_openvino_toolkit_${OPENVINO_VERSION}_x86_64"

echo "Instalação do OpenVINO concluída com sucesso!"

g++ -o /content/iaCppRemaster/iaCppRemaster /content/iaCppRemaster/src/iaCppRemaster.cpp `pkg-config --cflags --libs opencv4`

g++ -o /content/iaCppRemaster/iaCppVerticalFill /content/iaCppRemaster/src/iaCppVerticalFill.cpp \
    -I${OPENVINO_DIR}/runtime/include \
    -I/usr/include/opencv4 \
    -L${OPENVINO_DIR}/runtime/lib/intel64 \
    -L/usr/lib/x86_64-linux-gnu \
    -lopenvino -lopencv_core -lopencv_imgproc -lopencv_highgui \
    -lpython3.8 -lprotobuf -lssl -lcrypto -lstdc++ -lpthread -ldl