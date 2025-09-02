#!/bin/bash

# Nombre del archivo que contiene las dependencias
DEPENDENCIES_FILE="dependencies.txt"

# Función para verificar si un paquete está instalado
verify() {
    local package=$1
    if dpkg -l | grep -q "$package"; then
        echo "$package installed"
    else
        echo "$package not installed"
    fi
}

# Verificar si el archivo de dependencias existe
if [ ! -f "$DEPENDENCIES_FILE" ]; then
    echo "Dependencies file not exist ($DEPENDENCIES_FILE)"
    exit 1
fi

# Leer las dependencias del archivo y verificar si están instaladas
while IFS= read -r dependency; do
    verify "$dependency"
done < "$DEPENDENCIES_FILE"
