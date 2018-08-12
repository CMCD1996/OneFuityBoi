# Optimites: OneFruityBoi
# Connor McDowall 530913386 cmcd398
# Josh  Beckett 528396260 jbec200
# Alexander Zhao 619051233 azha755
# Optimisation Model File

# Set all the parameters
set AVOCADO_SUPPLIERS;
set APPLE_SUPPLIERS;
set AVOCADO_DEMAND;
set APPLE_DEMAND;
set PERIODS;
set PACKMACHINE;
set PACKHOUSE;

# Create Total Supply and Demand Nodes
set SUPPLIERS := AVOCADO_SUPPLIERS union APPLE_SUPPLIERS;
set MARKETS := AVOCADO_DEMAND union APPLE_DEMAND;

# Create a set of avocado nodes and apples nodes
set AVNODES:= AVOCADO_SUPPLIERS union PACKHOUSE union AVOCADO_DEMAND;
set APNODES:= APPLE_SUPPLIERS union PACKHOUSE union APPLE_DEMAND;

# Create the two sets of ARCS, one for avocados, one for apples. that span the wharehouses
set AVARCS:= (AVOCADO_SUPPLIERS cross PACKHOUSE) union (PACKHOUSE cross AVOCADO_DEMAND);
set APARCS:= (APPLE_SUPPLIERS cross PACKHOUSE) union (PACKHOUSE cross APPLE_DEMAND);

# Set the lower and upper bounds for avocado arcs
param AVLower{AVARCS} >=0, default 0;
param AVUpper{(i,j) in AVARCS} >= AVLower[i,j], default infinity;

# Set the lower and upper bounds for apple arcs
param APLower{AVARCS} >=0, default 0;
param APUpper{(i,j) in APARCS} >= AVLower[i,j], default infinity;

# Set all the parameters for Supply and Demand
param supply{SUPPLIERS,PERIODS};
param demand{MARKETS,PERIODS};
param rate{PACKMACHINE};
param packcost{PACKMACHINE};

# Do the cost tables and costs flows
param supplycost{SUPPLIERS,PACKHOUSE};
param marketcost{PACKHOUSE, MARKETS};
param AVCost{AVARCS} default 0;
param APCost{AVARCS} default 0;

# Set the Net Demand Node flow, ALL to specify all periods.
param AVNetDemand {n in AVNODES, p in PERIODS}
	:= if n in AVOCADO_SUPPLIERS then -supply[n,'ALL'] else if n in AVOCADO_DEMAND
	then demand[n,p];
	
# Set the Net Demand Node flow
param APNetDemand {n in APNODES, p in PERIODS}
	:= if n in APPLE_SUPPLIERS then -supply[n,'ALL'] else if n in APPLE_DEMAND
	then demand[n,p];

# Check to make sure S =  Demand creating dummy supply and demand nodes and amoiunts when necessary
# Create variables
# Three Dimensional
var AVFlow {(i,j) in AVARCS, p in PERIODS} >= 0, integer
var APFlow{(i,j) in APARCS, p in PERIODS} >= 0, integer
# Variable to control the number of machines to build.
var AVBuilt {PACKMACHINE, PACKHOUSE} >=0, integer
var APBuilt {PACKMACHINE, PACKHOUSE} >=0, integer

# Objective Function, a combination, something with the periods may need to be
# sorted here.
minimize TotalCost: sum{(i,j) in AVARCS,p in PERIODS} AVCost[i,j]*AVFlow[i,j,p]
					+ sum{m in PACKMACHINE, h in PACKHOUSE} packcost[m]*AVBuilt[m,h]
					+ sum{(i,j) in APARCS,p in PERIODS} APCost[i,j]*APFlow[i,j,p]
					+ sum{m in PACKMACHINE, h in PACKHOUSE} packcost[m]*AVBuilt[m,h];
					
# Constraints
# Ensure that APPLE Demand is met
subject to MeetDemand {j in AVOCADO_DEMAND,p in PERIODS}:
  sum {i in PACKHOUSE} AVFlow[i, j, p] >= demand[j,p];
  
# Ensure that the AVOCADO Demand is met
subject to MeetDemand {j in APPLE_DEMAND, p in PERIODS}:
  sum {i in PACKHOUSE} APFlow[i, j, p] >= demand[j,p]

# Ensure that avocado supply is not breached
subject to UseAVSupply {i in AVOCADO_SUPPLIERS}:
  sum {j in PACKHOUSE} AVFlow[i, j, 'ALL'] <= supply[i,'ALL'];
  
# Ensure that apple supply is not breached
subject to UseAPSupply {i in APPLE_SUPPLIERS}:
  sum {j in PACKHOUSE} APFlow[i, j,p ] <= supply[i,'ALL'];

# Must conserve flow at the packhouses, Need to do something with the wastage.
subject to APConserveFlow {i in PACKHOUSE, p in PERIODS}:
   sum {j in AVOCADO_SUPPLIERS} AVFlow[j,i,'ALL']= sum {j in AVOCADO_MARKET} Flow[i,j,p];

# Must conserve flow at the packhouses for Apples, Need to do something with the wastage.
subject to APConserveFlow {i in PACKHOUSE, p in PERIODS}:
   sum {j in APPLE_SUPPLIERS} APFlow[j,i,'ALL']= sum {j in APPLE_MARKET} Flow[i,j,p];

# Not exceed capacity at packhouse for each period (Avocados)
subject to CapacityOut {i in PACKHOUSE, p in PERIODS}:
   sum {m in PACKMACHINE}  AVBuilt[m, i]*rate[m] >= sum {j in AVOCADO_MARKET} Flow[i, j,p ];

# Not exceed capacity at packhouse for each period (Apples)
subject to CapacityOut {i in PACKHOUSE, p in PERIODS}:
   sum {m in PACKMACHINE}  APBuilt[m, i]*rate[m] >= sum {j in APPLE_MARKET} Flow[i, j, p];
   
# Model summary notes.
# Splitting the model into Avocado and Apple Flows so the machine is useful
# Splitting the machines up to tell the packhouses how many of each machine to configure.
# The trick is, this is two seperate problems, avocado and apples. We want to place the packing machines in wharehouses
# that minimise the cost. Since packing machines can't be used for both apples and avocados, they are mutually exclusive.
# You can formulate into one massive problem, flicking between the avocados and apples, through all the periods.
# Don't need to take all the supply, we buy from the suppliers and incur transporation costs. We want to minimise our wastage.
# We might need to do a dummy demand so the problem is naturally integer.
