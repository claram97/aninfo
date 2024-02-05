# Snake
TP Análisis de la Información. Curso Camejo. 2do cuatrimestre 2023. Implementación del juego Snake en Lua, utilizando Love2D para el desarrollo de la interfaz gráfica. 
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

-Descargar y correr el instalador.

---

## Correr un hola mundo en lua

1. Crear un archivo hola_mundo.lua
2. Escribir print("¡Hola, mundo!")
3. Ir a la carpeta del proyecto y correr por línea de comandos `lua hola_mundo.lua`.

## Para correr un proyecto hecho en Love2D

Creamos una carpeta para nuestro proyecto y dentro de esa carpeta creamos un **main.lua**. Es importante que el archivo se llame main.
Dentro del main.lua podemos escribir por ejemplo:
```
function love.draw()
	love.graphics.print("Hello World!", 400, 300)
end
```

Adicionalmente, podemos hacer un archivo de configuración conf.lua

function love.conf(t)
    t.window.title = "Hola Mundo en Love2D"
    t.window.width = 800
    t.window.height = 600
end

Luego, vamos a la carpeta que contiene a la carpeta del proyecto. Es decir si el main.lua fue creado en /Desktop/lua/proyecto/, nos paramos en /Desktop/lua y corremos love proyecto en la terminal.
