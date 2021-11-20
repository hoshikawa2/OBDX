from java.io import FileInputStream

print("*** Trying to Connect.... *****")
connect('weblogic','welcome1','t3://127.0.0.1:7001')
print("*** Connected *****")

start('OBDX_MS11')

disconnect()
exit()

