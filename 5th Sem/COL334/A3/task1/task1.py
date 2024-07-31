import matplotlib.pyplot as plt
import pandas as pd



def parta():
	file1 = "NewReno.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("NewReno: ",df1.max())
	df1.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("New Reno")
	plt.savefig("NewReno_cwnd.png", index = False)

	file2 = "WestWood.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("WestWood: ",df2.max())
	df2.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("WestWood")
	plt.savefig("WestWood_cwnd.png", index = False)

	file3 = "Veno.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("Veno: ",df3.max())
	df3.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("Veno")
	plt.savefig("Veno_cwnd.png", index = False)

	file4 = "Vegas.csv"
	df4 = pd.read_csv(file4, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("Vegas: ", df4.max())
	df4.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("Vegas")
	plt.savefig("Vegas_cwnd.png", index = False)

'''
def partb():
	file1 = "NewReno.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	count = 0
	for index, row in df1.iterrows():
		if(row['New Cwnd'] < row['Old Cwnd']):
			count += 1
	print("No of dropped packets in NewReno protocol: " + str(count))
	
	file2 = "HighSpeed.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	count = 0
	for index, row in df2.iterrows():
		if(row['New Cwnd'] < row['Old Cwnd']):
			count += 1
	print("No of dropped packets in HighSpeed protocol: " + str(count))
	
	file3 = "Veno.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	count = 0
	for index, row in df3.iterrows():
		if(row['New Cwnd'] < row['Old Cwnd']):
			count += 1
	print("No of dropped packets in Veno protocol: " + str(count))
	
	file4 = "Vegas.csv"
	df4 = pd.read_csv(file4, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	count = 0
	for index, row in df1.iterrows():
		if(row['New Cwnd'] < row['Old Cwnd']):
			count += 1
	print("No of dropped packets in Vegas protocol: " + str(count))
'''
parta()
