import requests
import json

def extraer_datos_criaturas(url):
    """
    Descarga un archivo JSON desde una URL, extrae datos específicos de las criaturas
    y los presenta en formato de lista.
    """
    try:
        # 1. Descargar el contenido JSON
        print(f"Intentando descargar datos desde: {url}")
        respuesta = requests.get(url, timeout=10)
        respuesta.raise_for_status()  # Genera un error para códigos de estado 4xx/5xx

        datos_json = respuesta.json()

        datos_extraidos = []
        
        # 2. Iterar sobre cada criatura (es una lista de diccionarios)
        for atributos in datos_json:
            
            # 3. Extraer los campos solicitados
            criatura_data = {
                "ID": atributos.get("ID", "N/A"),
                "Number": atributos.get("Number", "N/A"),
                "Name": atributos.get("Name", "N/A").replace("!!", ""), # Limpia prefijos como "!!"
                "MinHP": atributos.get("MinHP", "N/A"),
                "MaxHP": atributos.get("MaxHP", "N/A")
            }
            datos_extraidos.append(criatura_data)

        return datos_extraidos

    except requests.exceptions.RequestException as e:
        print(f"\nERROR al acceder a la URL o descargar los datos: {e}")
        print("Asegúrate de que la URL esté activa y sea accesible.")
        return None
    except json.JSONDecodeError:
        print("\nERROR: El contenido descargado no es un JSON válido.")
        return None

# URL proporcionada por el usuario
URL_CREATURES = "https://cardwarskingdom.pythonanywhere.com/persist/static/Blueprints/db_Creatures.json"

# Ejecutar la función
resultados = extraer_datos_criaturas(URL_CREATURES)

# Mostrar los resultados
if resultados:
    print("\n--- Datos de Criaturas Extraídos ---\n")
    # Imprimir encabezado de tabla
    print(f"{'ID':<25} {'Number':<10} {'Name':<20} {'MinHP':<10} {'MaxHP':<10} {'HP':<10}")
    print("-" * 100)
    
    # Imprimir filas de datos
    for criatura in resultados:

        HP_promedio = (float(criatura['MinHP']) + float(criatura['MaxHP'])) / 2
        criatura['HP'] = HP_promedio

        print(f"{criatura['ID']:<25} {criatura['Number']:<10} {criatura['Name']:<20} {criatura['MinHP']:<10} {criatura['MaxHP']:<10} {criatura['HP']:<10}")