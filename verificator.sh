#!/bin/bash

# Nombre del archivo que contiene las dependencias
DEPENDENCIES_FILE="dependencies.txt"

# Función para verificar si un paquete está instalado y versión
verify() {
    local package=$1
    local expected_version=$2
    
    # Verificar si el paquete está instalado
    if dpkg -l | grep -q "^ii.*$package "; then
        if [ -n "$expected_version" ]; then
            # Obtener la versión instalada
            local installed_version=$(dpkg -l | grep "^ii.*$package " | awk '{print $3}')
            if [[ "$installed_version" == *"$expected_version"* ]]; then
                echo "$package installed with correct version ($expected_version)"
            else
                echo "$package installed with version $installed_version, expected $expected_version"
            fi
        else
            local installed_version=$(dpkg -l | grep "^ii.*$package " | awk '{print $3}')
            echo "$package installed with version $installed_version"
        fi
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
    # Ignorar líneas vacías y comentarios
    if [ -n "$dependency" ] && ! [[ "$dependency" =~ ^[[:space:]]*# ]]; then
        # Formato: paquete version
        package=$(echo "$dependency" | awk '{print $1}')
        version=$(echo "$dependency" | awk '{print $2}')
        verify "$package" "$version"
    fi
done < "$DEPENDENCIES_FILE"
