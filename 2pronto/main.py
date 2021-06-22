import question1
import question2
import question3

def printMenu():
    print("Selecione uma das opções abaixo:")
    print("(1) Executar questão 1")
    print("(2) Executar questão 2")
    print("(3) Executar questão 3")
    print("Digite outro caractere para finalizar execução\n")

while(1):
    printMenu()
    option = input()
    if option == '1':
        question1.run()
    elif option == '2':
        question2.run()
    elif option == '3':
        question3.run()
    else:
        print("Finalizando programa...")
        exit()



