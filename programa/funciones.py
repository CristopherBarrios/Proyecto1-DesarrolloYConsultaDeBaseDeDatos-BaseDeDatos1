import psycopg2
import pandas as pd
import xml.etree.ElementTree as ET



def deleteTable():
    '''Elimina una tabla de la base de datos proyecto1 que se le pida
    '''
    conn = psycopg2.connect(
    database = 'proyecto1', user='postgres', password='1234567', host='127.0.0.1', port='5432'
        )
    cursor = conn.cursor()
    FileName = input("Ingrese nombre de tabla a eliminar: ")
    cursor.execute("DROP TABLE IF EXISTS " + FileName.lower())
    conn.commit()
    conn.close()


def csvToPostgre():
    '''Funcion que convierte los datos que estan en .csv a la base de datos llamada proyecto1 en postgree,
    Toma los datos que estan en la primera fila con el fin de insertarlos en sus respectivas columnas,
    La tabla tiene que estar ya creada o de lo contrario hbra un error
    '''
    FileName = input("\n\n\tEnter DATA File Name: ")
    print("\n\n\tStart loading File: " + FileName + ".csv")

    filePath = "Proyecto1-Datos/" + FileName + ".csv"#ubicacion de los csv
    df = pd.read_csv(filePath)# lee el csv
    df = df.replace({pd.np.nan: None})#manejo correcto de lo valores nulos

    # coneccion con postgre
    conn = psycopg2.connect(
        database = 'proyecto1', user='postgres', password='1234567', host='127.0.0.1', port='5432'
    )
    print(len(list(df.columns)))

    #Agrupamos las columnas y los valores a insertar
    indices = ""
    valu = ""
    for a in df.columns:
        if a == "cross":#uno de los nombres de las columnas coincide con la programacion en sql y genera error, esto es para evitarlo
            a = '"' + a + '"'
        indices += " " + a + ","#las columnas a insertar
        valu +=  "%s,"#cantidad de la valores a insertar

    indices=indices[:-1]
    valu=valu[:-1]
        
    cursor = conn.cursor()

    cursor.execute("select version()")
    count = 0

    for row in df.itertuples(index=False):
        count = count+1
        print(str(count)+" ==> "+str(row))

        columnas = list(row)
        if FileName == "Match":
            if columnas[80] != None:
                foulcommit = columnas[80]
               # print("----------------------------")
                #print(foulcommit)
                valFoucommit(foulcommit)
                #print("----------------------------")
        new_insert = (columnas)#valores del csv que se quieren insertar
        cursor.execute("INSERT INTO public."+FileName+"("+indices+") VALUES ("+valu+");", new_insert)#usamos sql

    conn.commit()
    conn.close()#cerramos la base de datos


def createTable():
    '''Crea tablas en la base de datos proyecto 1, solo con el tipo de dato varchar o int, aunque no es preciso es util cuando se tienen demasiadas columnas en el csv
    '''
    FileName = input("\n\n\tEnter File Name To Create Table: ")
    print("\n\n\tStart loading File: " + FileName + ".csv")

    filePath = "Proyecto1-Datos/" + FileName + ".csv"
    df = pd.read_csv(filePath)

    indices = ""
    count = 0
    for a, row in zip(df.columns,df.itertuples()):
        if a == "cross":
            a = '"' + a + '"'
        count = count+1
        print(type(row[count])) 
        if type(row[count]) == int:
            valor = "INT"
        else:
            valor = "VARCHAR(10000)"
        indices += "\n\t" + a + " " + valor + ","

    indices=indices[:-1]

    conn = psycopg2.connect(
        database = 'proyecto1', user='postgres', password='1234567', host='127.0.0.1', port='5432'
    )

    cursor = conn.cursor()
    print("CREATE TABLE " + FileName.lower() +" ("+ indices +");")
    cursor.execute("CREATE TABLE " + FileName.lower() +" ("+ indices +");")

    conn.commit()
    conn.close()
    

def valFoucommit(archivo):
    # Crear una conexión a la base de datos y un cursor
    conn = psycopg2.connect(
        database = 'proyecto1', user='postgres', password='1234567', host='127.0.0.1', port='5432'
            )
    cursor = conn.cursor()
# #Crear la tabla "foulcommit"
# cursor.execute('''CREATE TABLE foulcommit
#              (id INTEGER, foulscommitted INTEGER, event_incident_typefk INTEGER, elapsed INTEGER,
#               player2 INTEGER, subtype TEXT, player1 INTEGER, sortorder INTEGER, team INTEGER,
#               n INTEGER, type TEXT)''')
    # Analizar el archivo XML
    root = ET.fromstring(archivo)

# tree = ET.parse('./wdfg.xml')
# root = tree.getroot()

    # Recorrer cada elemento "value" en el archivo XML
    for value in root.iter('value'):
        # Obtener los valores de cada elemento en el elemento "value"
        if value.find('id') is not None:
            id = value.find('id').text
        else:
            id = None
        if value.find('.//foulscommitted') is not None:
            foulscommitted = value.find('.//foulscommitted').text
        else:
            foulscommitted = None
        if value.find('event_incident_typefk') is not None:
            event_incident_typefk = value.find('event_incident_typefk').text
        else:
            event_incident_typefk = None
        if value.find('elapsed') is not None:
            elapsed = value.find('elapsed').text
        else:
            elapsed = None
        if value.find('player2') is not None:
            player2 = value.find('player2').text
        else:
            player2 = None

        if value.find('subtype') is not None:
            subtype = value.find('subtype').text
        else:
            subtype = None

        if value.find('player1') is not None:
            player1 = value.find('player1').text
            if player1 == "Unknown player":
                player1 = None
        else:
            player1 = None
        if value.find('sortorder') is not None:
            sortorder = value.find('sortorder').text
        else:
            sortorder = None
        if value.find('team') is not None:
            team = value.find('team').text
        else:
            team = None
        if value.find('n') is not None:
            n = value.find('n').text
        else:
            n = None
        if value.find('type') is not None:
            type = value.find('type').text
        else:
            type = None
        
        # Insertar los valores en la tabla "foulcommit"
        cursor.execute("INSERT INTO foulcommit VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (id, foulscommitted, event_incident_typefk, elapsed, player2, subtype, player1, sortorder, team, n, type))

    # Confirmar los cambios y cerrar la conexión
    conn.commit()
    conn.close()

    print("insertado")