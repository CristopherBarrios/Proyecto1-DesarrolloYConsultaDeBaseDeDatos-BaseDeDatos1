from programa.funciones import *



# functions ________________________
def bienvenido():
    print("")
    print("========================================================")
    print("---------------------- Bienvenido ----------------------")
    print("========================================================")
    print("")


def menuPrincipal():
    print("")
    print("Selecionar opcion: ")
    print("1. Crear tabla")
    print("2. Importar .csv a postgresql")
    print("3. Eliminar tabla")
    print("4. Salir del programa")
    print("")


def menuTabla():
    print("Cual es el nombre de su tabla?: ")


# menu interactivo ________________________
def main():
    bienvenido()

    while True:
        menuPrincipal()
        option = input('Ingrese una opcion: ')
        print("")
        if(option == '1'):
            print("")
            createTable()
        if(option == '2'):
            print("")           
            csvToPostgre()
        if(option == '3'):
            print("")
            deleteTable()
        elif(option == '4'):
            print('Adios! ')
            break
        else:
            input('No se ha elejido ninguna opcion en el menu. Intentalo de nuevo! Enter -->')
        