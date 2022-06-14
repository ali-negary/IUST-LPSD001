# # and gates
# for i in range(0,8):
#     for j in range(0,8):
#         and_gate_net = f"Xandgate{i}{j}   A{i}   B{j}   andout{i}{j}   AND" 
#         print(and_gate_net)

# halfadders
# for i in range (1,8):
#     print(f"Xhalfadder{i}   andout0{i}   outfa{i-1}1   outP{i}   hacarry{i}   halfadder")

# fulladders: first row
# for i in range(1,7):
#     full_adder_net = f"Xfulladder0{i}   andout{i+1}0   andout{i}1   outfa0{i-1}   outfa0{i}   facarry0{i}   fulladder"
#     print(full_adder_net)

# fulladders: next rows - first column
# for i in range(1,7):
#     full_adder_net = f"Xfulladder{i}1   outfa{i-1}2   andout1{i+1}   hacarry{i+1}   outfa{i}1   facarry{i}1   fulladder"
#     print(full_adder_net)

# fulladders: rest of the rows
# for i in range(1,7):
#     for j in range(2,8):
#         if i == 1 and j == 6:
#             full_adder_net = " "
#         else:
#             full_adder_net = f"Xfulladder{i}{j}   facarry{i}{j-1}   outfa{i-1}{j+1}   andout{j}{i+1}   outfa{i}{j}   facarry{i}{j}   fulladder"
#         print(full_adder_net)

# input provider
# def Vwriter(word, value):
#     for i in range(0,len(value)):
#         if value[i] == '1':
#             input_provider = f"V{word}{i}   {word}{i}   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)"
#         else:
#             input_provider = f"V{word}{i}   {word}{i}   VSS pulse(0 0 0 0.01ns 0.01ns 5ns 10ns)"
#         print(input_provider)

# Vwriter(word='XX', value='11111111')
# print("*******************")
# Vwriter(word='YY', value='11111110')