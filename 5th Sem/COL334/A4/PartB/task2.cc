#include <fstream>
#include "ns3/core-module.h"
#include "ns3/internet-module.h"
#include "ns3/csma-module.h"
#include "ns3/internet-apps-module.h"
#include "ns3/ipv4-static-routing-helper.h"
#include "ns3/ipv4-routing-table-entry.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("Second");

void TearDownLink (Ptr<Node> nodeA, Ptr<Node> nodeB, uint32_t interfaceA, uint32_t interfaceB)
{
  nodeA->GetObject<Ipv4> ()->SetDown (interfaceA);
  nodeB->GetObject<Ipv4> ()->SetDown (interfaceB);
}

int main (int argc, char **argv){

    CommandLine cmd;
    cmd.Parse (argc, argv);
    bool printRoutingTables = true;
    bool showPings = false;

    Config::SetDefault ("ns3::Rip::SplitHorizon", EnumValue (RipNg::SPLIT_HORIZON));

    NS_LOG_INFO ("Create nodes.");
    Ptr<Node> src = CreateObject<Node> ();
    Names::Add ("SrcNode", src);
    Ptr<Node> dst = CreateObject<Node> ();
    Names::Add ("DstNode", dst);
    Ptr<Node> R1 = CreateObject<Node> ();
    Names::Add ("Router1", R1);
    Ptr<Node> R2 = CreateObject<Node> ();
    Names::Add ("Router2", R2);
    Ptr<Node> R3 = CreateObject<Node> ();
    Names::Add ("Router3", R3);
    NodeContainer net1 = NodeContainer (src, R1);
    NodeContainer net2 = NodeContainer (R1, R2);
    NodeContainer net3 = NodeContainer (R1, R3);
    NodeContainer net4 = NodeContainer (R2, R3);
    NodeContainer net5 = NodeContainer (R3, dst);
    NodeContainer nodes = NodeContainer (src, dst);
    NodeContainer routers = NodeContainer (R1, R2, R3);

    NS_LOG_INFO ("Create channels.");

    CsmaHelper csma;
    csma.SetChannelAttribute ("DataRate", DataRateValue (5000000));
    csma.SetChannelAttribute ("Delay", TimeValue (MilliSeconds (2)));

    NetDeviceContainer ndc1 = csma.Install (net1);
    NetDeviceContainer ndc2 = csma.Install (net2);
    NetDeviceContainer ndc3 = csma.Install (net3);
    NetDeviceContainer ndc4 = csma.Install (net4);
    NetDeviceContainer ndc5 = csma.Install (net5);

    NS_LOG_INFO ("Create IPv4 and routing");
    RipHelper ripRouting;

    ripRouting.ExcludeInterface (R1, 1);
    ripRouting.ExcludeInterface (R3, 3);

    Ipv4ListRoutingHelper listRH;
    listRH.Add (ripRouting, 0);

    InternetStackHelper internet;
    internet.SetIpv6StackInstall (false);
    internet.SetRoutingHelper (listRH);
    internet.Install (routers);

    InternetStackHelper internetNodes;
    internetNodes.SetIpv6StackInstall (false);
    internetNodes.Install (nodes);

    NS_LOG_INFO ("Assign IPv4 Addresses.");
    Ipv4AddressHelper ipv4;

    ipv4.SetBase (Ipv4Address ("10.0.0.0"), Ipv4Mask ("255.255.255.0"));
    Ipv4InterfaceContainer iic1 = ipv4.Assign (ndc1);

    ipv4.SetBase (Ipv4Address ("10.0.1.0"), Ipv4Mask ("255.255.255.0"));
    Ipv4InterfaceContainer iic2 = ipv4.Assign (ndc2);

    ipv4.SetBase (Ipv4Address ("10.0.2.0"), Ipv4Mask ("255.255.255.0"));
    Ipv4InterfaceContainer iic3 = ipv4.Assign (ndc3);

    ipv4.SetBase (Ipv4Address ("10.0.3.0"), Ipv4Mask ("255.255.255.0"));
    Ipv4InterfaceContainer iic4 = ipv4.Assign (ndc4);

    ipv4.SetBase (Ipv4Address ("10.0.4.0"), Ipv4Mask ("255.255.255.0"));
    Ipv4InterfaceContainer iic5 = ipv4.Assign (ndc5);

    Ptr<Ipv4StaticRouting> staticRouting;
    staticRouting = Ipv4RoutingHelper::GetRouting <Ipv4StaticRouting> (src->GetObject<Ipv4> ()->GetRoutingProtocol ());
    staticRouting->SetDefaultRoute ("10.0.0.2", 1 );
    staticRouting = Ipv4RoutingHelper::GetRouting <Ipv4StaticRouting> (dst->GetObject<Ipv4> ()->GetRoutingProtocol ());
    staticRouting->SetDefaultRoute ("10.0.4.1", 1 );    

    if (printRoutingTables)
        {
        RipHelper routingHelper;

        Ptr<OutputStreamWrapper> routingStream = Create<OutputStreamWrapper> (&std::cout);

        routingHelper.PrintRoutingTableAt (Seconds (49.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (51.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (60.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (119.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (121.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (150.0), R1, routingStream);

        routingHelper.PrintRoutingTableAt (Seconds (70.0), R2, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (70.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (70.0), R3, routingStream);
        
        routingHelper.PrintRoutingTableAt (Seconds (121.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (121.0), R2, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (121.0), R3, routingStream);

        routingHelper.PrintRoutingTableAt (Seconds (180.0), R1, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (180.0), R2, routingStream);
        routingHelper.PrintRoutingTableAt (Seconds (180.0), R3, routingStream);
        }

    NS_LOG_INFO ("Create Applications.");
    uint32_t packetSize = 1024;
    Time interPacketInterval = Seconds (1.0);
    V4PingHelper ping ("10.0.4.2");

    ping.SetAttribute ("Interval", TimeValue (interPacketInterval));
    ping.SetAttribute ("Size", UintegerValue (packetSize));
    if (showPings)
        {
        ping.SetAttribute ("Verbose", BooleanValue (true));
        }
    ApplicationContainer apps = ping.Install (src);
    apps.Start (Seconds (1.0));
    apps.Stop (Seconds (600.0));

    AsciiTraceHelper ascii;
    csma.EnableAsciiAll (ascii.CreateFileStream ("rip-simple-routing.tr"));
    csma.EnablePcapAll ("rip-simple-routing", true);

    Simulator::Schedule (Seconds (50), &TearDownLink, R1, R2, 2, 1);
    Simulator::Schedule (Seconds (120), &TearDownLink, R1, R3, 3, 1);

    /* Now, do the actual simulation. */
    NS_LOG_INFO ("Run Simulation.");
    Simulator::Stop (Seconds (600.0));
    Simulator::Run ();
    Simulator::Destroy ();
    NS_LOG_INFO ("Done.");
}