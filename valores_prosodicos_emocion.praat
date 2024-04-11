# Román, Domingo y Muñoz, Diana
# 2024
# Laboratorio de Fonética USACH
# abril 2024
#
# valores_prosodicos_emocion.praat (v.01)
#
# 
# Script para Praat probado en la versión 6.4.01
# El código se encuentra disponible en https://github.com/DomingoRomanMontesDeOca/analisisEnPraat/edit/main/valores_prosodicos_emocion.praat
# También puede ser solicitado directamente a los creadores a sus correos electrónicos
# domingo.roman@usach.cl 
# diana.munoz815@gmail.com
###########################################################
# Este script es software libre: puede ser distribuido
# y/o modificado bajo los términos de la licencia
# GNU General Public License publicada por la Free Software
# Foundation, ya sea en su versión 3 o (según se prefiera)
# cualquier versión posterior.
# Este script se distribuye con la intención de que sea útil,
# pero SIN GARANTÍA ALGUNA; ni siquiera con la garantía
# implícita de COMERCIABILIDAD o de PROPIEDAD PARA UN FIN
# PARTICULAR. Más detalles pueden encontrarse en el texto de
# la GNU General Public License.
# El script debió haber sido distribuido con una copia de la
# GNU General Public License. Si no, este puede encontrarse en
# <http://www.gnu.org/licenses/>.
#
# Copyright 2024, Domingo Román y Diana Muñoz
#################################################


# Este script funciona teniendo seleccionados tres objetos relacionados:
#	· Pitch
#	· TextGrid
#	· Sound

# A partir de estos tres objetos, crea una tabla que contiene 
# 	· valores en duración (ms) de vocales marcadas
# 	· dB y Hz en puntos etiquetados
# 	· un valor (repetido para todas las filas) de promedio de Hz
#	· etiquetas en marcación ToBi en las dos últimas marcas
# además de una serie de variables que están codificadas en el nombre del archivo de audio.



# Asigna variables a los tres objetos seleccionados

sn = selected("Sound")
sn$ = selected$("Sound")
tg = selected("TextGrid")
tono = selected("Pitch")

# Crea objeto de intensidad
select sn
intensidad = To Intensity: 100, 0, "yes"


# Obtiene variables del nombre del archivo
ciudad$ = left$ (sn$,3)
sexo$ = mid$(sn$,5,1)
estrato$ = mid$ (sn$, 6,2)
n_informante$ = mid$(sn$,9,2)
emocion$ = mid$(sn$,12,1)
frase$ = mid$ (sn$, 13, 2)


# Obtiene número de puntos en el tier 3

select tg
ene_voc = Get number of points: 3


# Crea la tabla con las columnas necesarias 

tabla_diana = Create Table with column names: "table", ene_voc, {"audio", "n_informante", "ciudad", "sexo", "estrato", "frase", "emocion", "vocal", "dur_voc", "Hz", "dB", "XHz", "Tobi"}



# Obtiene valores y completa la tabla (paso A)

for i to ene_voc

	select tg
	
	voc_punto$ = Get label of point... 3 i

	tiempo_voc_punto = Get time of point... 3 i

	select tono
	valor_Hz = Get value at time: tiempo_voc_punto, "Hertz", "linear"
	xHz = Get mean: 0, 0, "Hertz"
	

	select intensidad
	valor_dB = Get value at time: tiempo_voc_punto, "cubic"

	select tabla_diana
	Set string value: i, "audio", sn$
	Set string value: i, "n_informante", n_informante$
	Set string value: i, "ciudad", ciudad$
	Set string value: i, "sexo", sexo$
	Set string value: i, "estrato", estrato$
	Set string value: i, "frase", frase$
	Set string value: i, "emocion", emocion$
	Set string value: i, "vocal", voc_punto$
	Set numeric value: i, "Hz", valor_Hz
	Set numeric value: i, "dB", valor_dB
	Set numeric value: i, "XHz", xHz
endfor



# Completa la tabla con los valores de etiquetas ToBi (Paso B).

select tabla_diana

n_filas = Get number of rows

select tg

tobi1$ = Get label of point... 4 1

tobi2$ = Get label of point... 4 2

select tabla_diana

Set string value: n_filas-1, "Tobi", tobi1$

Set string value: n_filas, "Tobi", tobi2$



# Obtiene la duración de las vocales y se incorporan esos datos a la tabla (Paso C).

select tg
intervalos_tier_2 = Get number of intervals: 2

contar = 0

for i to intervalos_tier_2

	select tg

	etiq_tier_2$ = Get label of interval: 2, i

	if etiq_tier_2$ <> ""

			contar = contar + 1

			ini = Get start time of interval: 2, i

			fin = Get end time of interval: 2, i

			dur = (fin-ini)*1000

			select tabla_diana

			Set numeric value: contar, "dur_voc", dur

	endif

endfor


# Elimina el objeto Intensity del panel de objetos.

select intensidad

Remove




