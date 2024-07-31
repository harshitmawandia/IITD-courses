import matplotlib.pyplot as plt
import pandas as pd



def parta():
	file1 = "connection1.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("NewReno: ",df1.max())
	df1.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection1")
	plt.savefig("connection1.png", index = False)

	file2 = "connection2.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("WestWood: ",df2.max())
	df2.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection2")
	plt.savefig("connection2.png", index = False)

	file3 = "connection3.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("Veno: ",df3.max())
	df3.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection3")
	plt.savefig("connection3.png", index = False)

def partb():
	file1 = "reno_connection1.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("NewReno: ",df1.max())
	df1.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection1")
	plt.savefig("connection1_new.png", index = False)

	file2 = "reno_connection2.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("WestWood: ",df2.max())
	df2.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection2")
	plt.savefig("connection2_new.png", index = False)

	file3 = "reno_connection3.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print("Veno: ",df3.max())
	df3.plot(x = 'Time', y = 'New Cwnd', label = 'Cwnd size')
	plt.legend()
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.title("connection3")
	plt.savefig("connection3_new.png", index = False)


	
parta()
partb()
