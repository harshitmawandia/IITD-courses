l = [0,
1,
2,
3,
4,
5,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
17
]

l2 = ["E3A00006",
"E3A01002",
"E0812000",
"E0403001",
"E0004001",
"E0205001",
"E0616000",
"E0A07001",
"E0C08001",
"E0E19000",
"E1100001",
"E1300001",
"E1500001",
"E1700001",
"E180E001",
"E1A0F000",
"E1C03001",
"E1E04000",
]

l3=[]

for i in range(18):
    l3.append(str(l[i])+" => x\""+l2[i]+"\"")
    print(l3)

