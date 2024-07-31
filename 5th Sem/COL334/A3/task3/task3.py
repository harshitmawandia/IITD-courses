import matplotlib.pyplot as plt
import pandas as pd

def parta():
	file1 = "task3_TCP.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	print(df1)
	df1.plot(x = 'Time', y = 'New Cwnd', label = "TCP Connection")
	plt.legend()
	plt.title("TCP Congestion with time")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("task3.png", index = False)

parta()
# partb()