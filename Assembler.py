

# coding: utf-8


import re
from numpy import little_endian
import pandas as pd
from iic2343 import Basys3


rom_programmer = Basys3()


df = pd.read_excel('senales_de_control_2.xlsx', skiprows = 3, usecols = 'C:F', converters={'Opcode (6:0)':str})

#path = '.\Test 2 - Indirecto y Stack.txt'
#path = '.\Test 1 - Ram y Status.txt'
#path = '.\E2 - Programa 3.txt'
#path = '.\Test3.txt'
#path = '.\jugo.txt'
path = '.\juego2.txt'
#path = ".\d4.txt"

with open(path) as file:
    file = file.read()



i = 0 
lines = re.split(r'\n', file)
for line in lines:
    regex = re.search(':', line)
    if bool(regex):
        idx = regex.start() + 1
        lines[i] = lines[i][:idx]
    i+=1

"""
i = 0
for char in file:
    if char == ':':
        file = file[0: i+1]+'\n'+file[i+2:]
    i+=1
"""


df.columns = ['ins', 'op1', 'op2', 'opcode']
df = df.fillna('')
df



#print(file)

print(lines)




#lines = re.split(r'\n', file)

#print(lines)



"""
for i in range(len(lines)):
    if ":" in lines[i]:
        for j in range(len(lines[i])):
            if lines[i][j] == ":":
                lines[i] = lines[0:j] + "\n"
"""

for i in range(len(lines)):
    lines[i] = re.sub(r'\s+', ' ', lines[i])
    lines[i] = re.split('//', lines[i])[0]
    lines[i] = lines[i].strip()
lines = list(filter(None, lines))

i = 0
for line in lines:
    if line == 'CODE:':
        break
    i+=1
data = lines[1: i]
code = lines[i+1:]

i = 0

for dat in data:
    s = dat.split()
    if len(s) == 1:
        data[i] = ' ' + data[i]
    i+=1

i = 0
for cod in code:
    if cod == 'RET' or cod == 'NOP':
        code[i] = cod+' '
    i+=1
code
for cod in code:
    print(cod)



data




#data_pattern = r'(\w*)\s{0,1}(\d+)(\D{0,1})'
data_pattern = r'(\w*)\s{0,1}([\d|A|B|C|D|E|F]+)([h|b|d]{0,1})'

var_labels = {}
cambio_base = {'h' : 16, 'd':10, 'b': 2, '': 10}

i = 0
for dat in data:
    pattern = re.compile(data_pattern)
    for match in pattern.finditer(dat):
        dato_i = list(match.groups())
        dato_i[0] = dato_i[0].strip()
        label = dato_i[0]
        if label!= '':
            valor = format(int(dato_i[1], base = cambio_base[dato_i[2]]), '016b')
            var_labels[label] = format(i, '016b')
        i+=1


var_labels



ins = []



i = 0
for dat in data:
    pattern = re.compile(data_pattern)
    for match in pattern.finditer(dat):
        dato_i = list(match.groups())
        dato_i[0] = dato_i[0].strip()

        valor = format(int(dato_i[1], base = cambio_base[dato_i[2]]), '016b')
        #print(f'Instrucción{i}')
        print(f'MOV B, {dato_i[1]+dato_i[2]}')
        
        lit = valor
        opcode1 = df[(df.ins=='MOV') & (df.op1=='B') & (df.op2=='Lit')].opcode.values[0]
        ins.append(lit+'0'*13+opcode1)
        
        dir_ = format(i, '016b')
        print(f'MOV ({dir_}), B')
        lit2 = dir_
        opcode2 = df[(df.ins=='MOV') & (df.op1=='(Dir)') & (df.op2=='B')].opcode.values[0]
        ins.append(lit2+'0'*13+opcode2)         
        print('\n')
        
        i+=1






#code_pattern = r'(\w{3,4}\s{0,1}|\w+:)([^,;]*),{0,1}(.*)'
code_pattern = r'(\w{2,4} |\w+:)([^,;]*),{0,1}(.*)'
dir_labels = {}

i = len(data)*2
for cod in code:
    pattern = re.compile(code_pattern)
    for match in pattern.finditer(cod):
        code_i = list(match.groups())
        code_i = [re.sub(r'\s+', "", string) for string in code_i]     
        #print(f'{code[i]:<15}{code_i}')
        label = code_i[0]
    if ':' in label:
        dir_labels[label] = i
    elif label != 'POP' and label != 'RET':
        i+=1
    else:
        i+=2
dir_labels




def filtrar_operando(operando):
    if operando == 'A' or operando =='B' or operando == '(A)' or operando =='(B)':
        return operando
    elif '(' in operando:
        return '(Dir)'
    else:
        return 'Lit'

def filtrar_literal2(operando):
    
    if operando == 'A' or operando =='B' or operando == '(A)' or operando =='(B)':
        return None
    
    elif '(' in operando: # mov, (var1) | mov a, (Ah)
        
        label = operando[1: -1]
        try:
            return var_labels[label]
        
        except KeyError:
            iden = identificar_num(label)
            
            if iden[1] == 'h':
                return format(int(iden[0], base = cambio_base['h']), '016b')
            elif iden[1] == 'b':
                return format(int(iden[0], base = cambio_base['b']), '016b')
            else:
                if label[-1]=='d':
                    label = label[:-1]
                return format(int(iden[0], base = cambio_base['d']), '016b')
        else: 
            return var_labels[label]
    
    else:
        try:
            label = operando
            return var_labels[label]
        
        except KeyError: #No es un label de variable
            if 'h' in operando:
                return format(int(operando[:-1], base = cambio_base['h']), '016b')
            elif 'b' in operando:
                return format(int(operando[:-1], base = cambio_base['b']), '016b')
            else:
                if label[-1]=='d':
                    label = label[:-1]
                return format(int(label, base = cambio_base['d']), '016b')


var_labels



def identificar_num(num):
    number_pattern = r'([\d|A|B|C|D|E|F]+)([h|b|d]{0,1})'
    pattern = re.compile(number_pattern)
    for match in pattern.finditer(num):
        matches = list(match.groups())
        matches = [re.sub(r'\s+', "", string) for string in matches]     
        return matches



print(dir_labels)

for cod in code:
    pattern = re.compile(code_pattern)
    for match in pattern.finditer(cod):
        code_i = list(match.groups())
        code_i = [re.sub(r'\s+', "", string) for string in code_i]     
        
        if code_i[2] != '': #Ins con 2 operandos
            print(code_i)
            #opcode = f'{code_i[0]} '+filtrar_operando(code_i[1])+','+filtrar_operando(code_i[2])
            opcode = df[(df.ins==code_i[0]) & 
                        (df.op1==filtrar_operando(code_i[1])) & 
                        (df.op2==filtrar_operando(code_i[2]))].opcode.values[0]
            
            if filtrar_literal2(code_i[1]) != None:
                
                ins.append(filtrar_literal2(code_i[1])+'0'*13+opcode)
                      
            elif filtrar_literal2(code_i[2]) != None:
                ins.append(filtrar_literal2(code_i[2])+'0'*13+opcode)
                      
            else:
                ins.append('0000000000000000'+'0'*13+opcode)
            print('\n')
            
        #elif code_i[1] != '' and code_i[2] == '' and code_i[0] in df.iloc[: , 0].unique():
        elif code_i[1] != '' and code_i[2] == '':
            print(code_i)
            if code_i[1] == 'A' or code_i[1] == 'B':
                
                if code_i[0] == 'DEC':
                    opcode = df[(df.ins=='SUB') & (df.op1==code_i[1]) & (df.op2=='Lit')].opcode.values[0]
                    ins.append(f'    0000000000000001'+'0'*13+opcode)
                    print('\n')

                elif code_i[0] == 'INC' and code_i[1] == 'A':
                    opcode = df[(df.ins=='ADD') & (df.op1==code_i[1]) & (df.op2=='Lit')].opcode.values[0]
                    ins.append(f'    0000000000000001'+'0'*13+opcode)

                    
                elif code_i[0] == 'POP':
                    opcode1 = df[(df.ins=='POP') & (df.op1==code_i[1])].opcode.values[0]
                    
                    ins.append(f'0000000000000000'+'0'*13+opcode1)
                    idx = df[(df.ins=='POP') & (df.op1==code_i[1])].index[0]+1
                    
                    opcode2 = df.loc[idx].opcode  
                    ins.append(f'0000000000000000'+'0'*13+opcode2)
                    print('\n')
                else:
                    opcode = df[(df.ins==code_i[0]) & 
                        (df.op1==filtrar_operando(code_i[1]))].opcode.values[0]
                    ins.append(f'0000000000000000'+'0'*13+opcode)
                    print('\n')
                    
            elif code_i[1]+':' in dir_labels:
                
                opcode = df[df.ins==code_i[0]].opcode.values[0]
                label = code_i[1]+':'
                num_ins = dir_labels[label]
                
                num_ins = format(int(str(num_ins), base = cambio_base['d']), '016b')
                ins.append(f'{num_ins}'+'0'*13+opcode)
                print('\n')
                
            elif code_i[1].startswith('('):
                label = code_i[1][1:-1]
                
                if label in var_labels: #label
                    opcode = df[(df.ins==code_i[0])&(df.op1=='(Dir)')].opcode.values[0]
                    lit = var_labels[label]                    
                    ins.append(f'{lit}'+'0'*13+opcode)
                    print('\n')
                    
                elif label=='B':
                    opcode = df[(df.ins==code_i[0])&(df.op1=='(B)')].opcode.values[0]
                    lit = '0'*16
                    ins.append(f'{lit}'+'0'*13+opcode)
                    print('\n')
                    
                else:
                    opcode = df[(df.ins==code_i[0])&(df.op1=='(Dir)')].opcode.values[0]
                    iden = identificar_num(label)
            
                    if iden[1] == 'h':
                        lit = format(int(iden[0], base = cambio_base['h']), '016b')
                    elif iden[1] == 'b':
                        lit =  format(int(iden[0], base = cambio_base['b']), '016b')
                    else:
                        if label[-1]=='d':
                            label = label[:-1]
                        lit = format(int(label, base = cambio_base['d']), '016b')
                        
                    ins.append(f'{lit}'+'0'*13+opcode)
                    print('\n')
                    
        elif code_i[0] in  df.iloc[: , 0].unique() and code_i[1] == '' and code_i[2] == '':
            print(code_i)
            if code_i[0]=='NOP':
                ins.append(f'0'*36)
                print('\n')
            else:
                opcode1 = df[df.ins=='RET'].opcode.values[0]
                    
                ins.append(f'0000000000000000'+'0'*13+opcode1)
                idx = df[df.ins=='RET'].index[0]+1

                opcode2 = df.loc[idx].opcode  
                ins.append(f'0000000000000000'+'0'*13+opcode2)
                print('\n')



#print(file)

#print(ins)


rom_programmer.begin(port_number = 1)
#000000000000001100000000000000110101

a = 0


for line in ins:
    line = line.strip()
    print(f"{line}  {a}")
    w = bytearray([int(str(line[0:4]) , base = 2), int(str(line[4:12]) , base = 2), int(str(line[12:20]) , base = 2), int(str(line[20:27]) , base = 2) , int(str(line[27:36]) , base = 2)])
    #print(w)
    #print(bytearray([(1)]))
    #print(f"{line} {w[0].hex()} {w[1].hex()} {w[2].hex()} {w[3].hex()} {w[4].hex()}")
    #print(f"{line}")
    #print(len(line))
    rom_programmer.write(a, w)
    a += 1


# MOV A,1
# 000000000000000100000000000000000010 
# 000000000000000100000000000000000010
"""
for i in range(120):
    print(rom_programmer.write(i, (0b000000000000000100000000000000000011).to_bytes(5,'big')))
"""


"""
print((0b00000000000000010000000000000010).to_bytes(5,'big'))
"""

rom_programmer.end()


