Trabajaremos con la versión 5.4.6 de Lua, que es la más actual hasta la fecha.
---
# Instalación de Lua en Linux o WSL. En particular, con Ubuntu 22.04.

### Opción 100% por consola:

1. `sudo apt install lua5.4`
2. `curl -R -O http://www.lua.org/ftp/lua-5.4.6.tar.gz`
3. `tar zxf lua-5.4.6.tar.gz`
4. `cd lua-5.4.6`
5. `make all test`
6. `sudo make all install`

Para comprobar que lua fue instalado, se puede correr `lua` por consola, lo que nos va a abrir un interpreter similar al de python donde vamos a poder escribir codigo ahi mismo.

### Opción interfaz gráfica o WSL con VSCode o similar:

1. Descargar el repositorio `lua-5.4.6.tar.gz` desde [La pagina oficial de Lua](https://www.lua.org/ftp/)
2. Descomprimir la carpeta. Si se trata de WSL, copiar la carpeta en WSL (aquí sirve un editor como VSCode que te deja copiar las carpetas directamente al WSL).
3. Building. Ir a la carpeta `lua-5.4.6` y `ejecutar make`. Si esto falla, correr make help para ver si la plataforma que estás utilizando es válida. Al encontrarla, corré make xxx.
4. Instalación. Correr `sudo make install`.

Nota: los pasos 3 y 4 pueden reemplazarse por `sudo make all install` o `sudo make xxx install`. (reemplazar con el nombre de la plataforma, por ejemplo linux)

* Para personalizar la instalación, puede leerse el readme que viene en la carpeta comprimida (se encuentra en doc/readme).

## Instalación en Windows:

En Windows, la versión 5.4 existe pero en el release 2.
Puede descargarse en: [luabinaries.sourceforge.net](https://luabinaries.sourceforge.net/download.html)

Descargamos la versión **lua-5.4.2_Win64_bin.zip** que es para Windows de 64 bits y posee los ejecutables.

### Paso a Paso
- Descomprimir en C:\Program Files\lua
- Abrir ajustes
- Buscar la opción en el buscado para "Editar las variables de entorno del sistema"
- Tocar el botón "Variables de entorno..."
- Seleccionar "path" en el recuadro de abajo.
- Clickear en el botón editar.
- Poner "examinar".
- Seleccionar la carpeta lua que descomprimimos en C:\Program Files.
- Abrir cmd
- Escribir lua54 para verificar que la versión esté instalada

En este punto, cualquiera sea el metodo de instalación, se deberia poder correr un archivo .lua haciendo `lua archivo.lua`.

---

# Love2D

Love2D es el framework que vamos a utilizar para el juego, particularmente **Love2D 11.4**

Love2D 11.4 Se descarga de [La pagina oficial del framework](https://love2d.org/)

O bien:

### Linux:

1. `sudo add-apt-repository ppa:bartbes/love-stable`
2. `sudo apt update`
3. `sudo apt install love`

### Windows:

- Descargar y correr el instalador.

- Similar a la [seccion anterior](#paso-a-paso) editar las variables de entorno agregando el path de love en el directorio instalado. 
---

## Correr el juego
Pararse en la carpeta root del proyecto, por default  `aninfo-main`, abrir una terminal y correr el comando:
```console
$ love snake
```
