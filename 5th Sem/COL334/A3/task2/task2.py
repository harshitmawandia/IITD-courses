import matplotlib.pyplot as plt
import pandas as pd

def parta():
	file1 = "task2_channel_3.000000_app_5.000000.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file2 = "task2_channel_5.000000_app_5.000000.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file3 = "task2_channel_10.000000_app_5.000000.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file4 = "task2_channel_15.000000_app_5.000000.csv"
	df4 = pd.read_csv(file4, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	file5 = "task2_channel_30.000000_app_5.000000.csv"
	df5 = pd.read_csv(file5, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	df1.plot(x = 'Time', y = 'New Cwnd', label = "Channel Data Rate: 3")
	plt.legend()
	plt.title("Channel Data Rate:3 - Application Data Rate:5 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("cdr_3_plot.png", index = False)
	
	df2.plot(x = 'Time', y = 'New Cwnd', label = "Channel Data Rate: 5")
	plt.legend()
	plt.title("Channel Data Rate:5 - Application Data Rate:5 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("cdr_5_plot.png", index = False)
	
	df3.plot(x = 'Time', y = 'New Cwnd', label = "Channel Data Rate: 10")
	plt.legend()
	plt.title("Channel Data Rate:10 - Application Data Rate:5 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("cdr_10_plot.png", index = False)
	
	df4.plot(x = 'Time', y = 'New Cwnd', label = "Channel Data Rate: 15")
	plt.legend()
	plt.title("Channel Data Rate:15 - Application Data Rate:5 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("cdr_15_plot.png", index = False)
	
	df5.plot(x = 'Time', y = 'New Cwnd', label = "Channel Data Rate: 30")
	plt.legend()
	plt.title("Channel Data Rate:30 - Application Data Rate:5 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("cdr_30_plot.png", index = False)

def partb():
	file1 = "task2_channel_4.000000_app_1.000000.csv"
	df1 = pd.read_csv(file1, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file2 = "task2_channel_4.000000_app_2.000000.csv"
	df2 = pd.read_csv(file2, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file3 = "task2_channel_4.000000_app_4.000000.csv"
	df3 = pd.read_csv(file3, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	file4 = "task2_channel_4.000000_app_8.000000.csv"
	df4 = pd.read_csv(file4, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])
	
	file5 = "task2_channel_4.000000_app_12.000000.csv"
	df5 = pd.read_csv(file5, header = None, names = ["Time", "Old Cwnd", "New Cwnd"])

	df1.plot(x = 'Time', y = 'New Cwnd', label = "Application Data Rate: 1")
	plt.legend()
	plt.title("Channel Data Rate:4 - Application Data Rate:1 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("adr_1_plot.png", index = False)
	
	df2.plot(x = 'Time', y = 'New Cwnd', label = "Application Data Rate: 8")
	plt.legend()
	plt.title("Channel Data Rate:4 - Application Data Rate:8 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("adr_8_plot.png", index = False)
	
	df3.plot(x = 'Time', y = 'New Cwnd', label = "Application Data Rate: 2")
	plt.legend()
	plt.title("Channel Data Rate:4 - Application Data Rate:2 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("adr_2_plot.png", index = False)
	
	df4.plot(x = 'Time', y = 'New Cwnd', label = "Application Data Rate: 4")
	plt.legend()
	plt.title("Channel Data Rate:4 - Application Data Rate:4 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("adr_4_plot.png", index = False)
	
	df5.plot(x = 'Time', y = 'New Cwnd', label = "Application Data Rate: 12")
	plt.legend()
	plt.title("Channel Data Rate:4 - Application Data Rate:12 ")
	plt.xlabel("Time(sec)")
	plt.ylabel("Cwnd size")
	plt.savefig("adr_12_plot.png", index = False)


# parta()
partb()