#include <fstream>
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include <bits/stdc++.h>

using namespace std;
using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("Task3");


class MyApp : public Application
{
public:
  MyApp ();
  virtual ~MyApp ();

  /**
   * Register this type.
   * \return The TypeId.
   */
  static TypeId GetTypeId (void);
  void Setup (Ptr<Socket> socket, Address address, uint32_t packetSize, uint32_t nPackets, DataRate dataRate);

private:
  virtual void StartApplication (void);
  virtual void StopApplication (void);

  void ScheduleTx (void);
  void SendPacket (void);

  Ptr<Socket>     m_socket;
  Address         m_peer;
  uint32_t        m_packetSize;
  uint32_t        m_nPackets;
  DataRate        m_dataRate;
  EventId         m_sendEvent;
  bool            m_running;
  uint32_t        m_packetsSent;
};

MyApp::MyApp ()
  : m_socket (0),
    m_peer (),
    m_packetSize (0),
    m_nPackets (0),
    m_dataRate (0),
    m_sendEvent (),
    m_running (false),
    m_packetsSent (0)
{
}

MyApp::~MyApp ()
{
  m_socket = 0;
}

/* static */
TypeId MyApp::GetTypeId (void)
{
  static TypeId tid = TypeId ("MyApp")
    .SetParent<Application> ()
    .SetGroupName ("Tutorial")
    .AddConstructor<MyApp> ()
    ;
  return tid;
}

void
MyApp::Setup (Ptr<Socket> socket, Address address, uint32_t packetSize, uint32_t nPackets, DataRate dataRate)
{
  m_socket = socket;
  m_peer = address;
  m_packetSize = packetSize;
  m_nPackets = nPackets;
  m_dataRate = dataRate;
}

void
MyApp::StartApplication (void)
{
  m_running = true;
  m_packetsSent = 0;
  m_socket->Bind ();
  m_socket->Connect (m_peer);
  SendPacket ();
}

void
MyApp::StopApplication (void)
{
  m_running = false;

  if (m_sendEvent.IsRunning ())
    {
      Simulator::Cancel (m_sendEvent);
    }

  if (m_socket)
    {
      m_socket->Close ();
    }
}

void
MyApp::SendPacket (void)
{
  Ptr<Packet> packet = Create<Packet> (m_packetSize);
  m_socket->Send (packet);

  if (++m_packetsSent < m_nPackets)
    {
      ScheduleTx ();
    }
}

void
MyApp::ScheduleTx (void)
{
  if (m_running)
    {
      Time tNext (Seconds (m_packetSize * 8 / static_cast<double> (m_dataRate.GetBitRate ())));
      m_sendEvent = Simulator::Schedule (tNext, &MyApp::SendPacket, this);
    }
}

static void
CwndChange (Ptr<OutputStreamWrapper> stream, uint32_t oldCwnd, uint32_t newCwnd)
{
  NS_LOG_UNCOND (Simulator::Now ().GetSeconds () << "\t" << newCwnd);
  *stream->GetStream () << Simulator::Now ().GetSeconds () << "\t" << oldCwnd << "\t" << newCwnd << std::endl;
}

static void
RxDrop (Ptr<PcapFileWrapper> file, Ptr<const Packet> p)
{
  NS_LOG_UNCOND ("RxDrop at " << Simulator::Now ().GetSeconds ());
  file->Write (Simulator::Now (), p);
}
int main (int argc, char *argv[]){
    cout << "Started" << endl;
    CommandLine cmd;
    cmd.Parse(argc, argv);


    NodeContainer nodes;
    nodes.Create (5);
    NodeContainer n0n1 = NodeContainer (nodes.Get (0), nodes.Get (1));
    NodeContainer n1n2 = NodeContainer (nodes.Get (1), nodes.Get (2));
    NodeContainer n2n3 = NodeContainer (nodes.Get (2), nodes.Get (3));
    NodeContainer n2n4 = NodeContainer (nodes.Get (2), nodes.Get (4));

    InternetStackHelper internet;
    internet.Install (nodes);

    NS_LOG_INFO ("Create channels.");

    PointToPointHelper p2p;
    p2p.SetDeviceAttribute ("DataRate", StringValue ("600Kbps"));
    p2p.SetChannelAttribute ("Delay", StringValue ("2ms"));

    NetDeviceContainer d0d1 = p2p.Install (n0n1);
    NetDeviceContainer d1d2 = p2p.Install (n1n2);
    NetDeviceContainer d2d3 = p2p.Install (n2n3);
    NetDeviceContainer d2d4 = p2p.Install (n2n4);

    // NetDeviceContainer devices = p2p.Install (nodes);

    NS_LOG_INFO ("Assign IP Addresses.");
    Ipv4AddressHelper ipv4;
    ipv4.SetBase ("10.1.1.0", "255.255.255.0");
    Ipv4InterfaceContainer i0i1 = ipv4.Assign (d0d1);

    ipv4.SetBase ("10.1.2.0", "255.255.255.0");
    Ipv4InterfaceContainer i1i2 = ipv4.Assign (d1d2);

    ipv4.SetBase ("10.1.3.0", "255.255.255.0");
    Ipv4InterfaceContainer i2i3 = ipv4.Assign (d2d3);

    ipv4.SetBase ("10.1.4.0", "255.255.255.0");
    Ipv4InterfaceContainer i2i4 = ipv4.Assign (d2d4);

    NS_LOG_INFO ("Use global routing.");
    Ipv4GlobalRoutingHelper::PopulateRoutingTables ();

    NS_LOG_INFO ("Create Applications.");


    uint16_t sinkPort = 8080;
    Address sinkAddress (InetSocketAddress (i2i3.GetAddress (1), sinkPort));
    PacketSinkHelper packetSinkHelper ("ns3::TcpSocketFactory", InetSocketAddress (Ipv4Address::GetAny (), sinkPort));
    ApplicationContainer sinkApps = packetSinkHelper.Install (nodes.Get (3));
    sinkApps.Start (Seconds (0.));
    sinkApps.Stop (Seconds (100.));

    TypeId tid = TypeId::LookupByName ("ns3::TcpVegas");
    Config::Set ("/NodeList/*/$ns3::TcpL4Protocol/SocketType", TypeIdValue (tid));

    Ptr<Socket> ns3TcpSocket = Socket::CreateSocket (nodes.Get (0), TcpSocketFactory::GetTypeId ());

    Ptr<MyApp> app = CreateObject<MyApp> ();
    app->Setup (ns3TcpSocket, sinkAddress, 1040, 100000, DataRate ("250Kbps"));
    nodes.Get (0)->AddApplication (app);
    app->SetStartTime (Seconds (1.));
    app->SetStopTime (Seconds (100.));

    uint16_t port = 9;
    Address sinkA (InetSocketAddress(i1i2.GetAddress (0), port));
    PacketSinkHelper sink ("ns3::UdpSocketFactory", InetSocketAddress(Ipv4Address::GetAny (), port));
    ApplicationContainer apps = sink.Install (nodes.Get (1));
    apps.Start (Seconds (40.));
    apps.Stop (Seconds (100.));

    Ptr<Socket> ns3UdpSocket = Socket::CreateSocket (nodes.Get (4), UdpSocketFactory::GetTypeId ());

    Ptr<MyApp> app2 = CreateObject<MyApp> ();
    app2->Setup (ns3UdpSocket, sinkA, 1040, 100000, DataRate ("250Kbps"));
    nodes.Get (4)->AddApplication (app2);
    app2->SetStartTime (Seconds (20.));
    app2->SetStopTime (Seconds (30.));

    Ptr<MyApp> app3 = CreateObject<MyApp> ();
    app3->Setup (ns3UdpSocket, sinkA, 1040, 100000, DataRate ("500Kbps"));
    nodes.Get (4)->AddApplication (app3);
    app3->SetStartTime (Seconds (30.));
    app3->SetStopTime (Seconds (100.));

    string toSave = "task3_TCP.csv";
    AsciiTraceHelper asciiTraceHelper;
    Ptr<OutputStreamWrapper> stream = asciiTraceHelper.CreateFileStream (toSave);
    ns3TcpSocket->TraceConnectWithoutContext ("CongestionWindow", MakeBoundCallback (&CwndChange, stream));

    PcapHelper pcapHelper;
    Ptr<PcapFileWrapper> file = pcapHelper.CreateFile ("task3.pcap", std::ios::out, PcapHelper::DLT_PPP);
    ns3TcpSocket->TraceConnectWithoutContext ("PhyRxDrop", MakeBoundCallback (&RxDrop, file));

    Simulator::Stop (Seconds (100));
    Simulator::Run ();
    Simulator::Destroy ();
    
    return 0;
}