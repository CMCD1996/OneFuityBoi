# Optimites: OneFruityBoi
# Connor McDowall 530913386 cmcd398
# Josh  Beckett 528396260 jbec200
# Alexander Zhao 619051233 azha755
# Optimisation Model File

###############################################################################################################################   
# Set all the parameters
###############################################################################################################################   
set AVOCADO_SUPPLIERS;
set APPLE_SUPPLIERS;
set AVOCADO_DEMAND;
set APPLE_DEMAND;
set PERIODS;
set PACKMACHINE;
set PACKHOUSE;
set TYPE;

# Create Total Supply and Demand Nodes
set SUPPLIERS := AVOCADO_SUPPLIERS union APPLE_SUPPLIERS;
set MARKETS := AVOCADO_DEMAND union APPLE_DEMAND;

# Create a complete set of nodes (Remove later as do not use)
set NODES:= SUPPLIERS union MARKETS union PACKHOUSE;

# Create a large set of ARCS
set ARCS := (SUPPLIERS cross PACKHOUSE) union (PACKHOUSE cross MARKETS);

###############################################################################################################################   
# Set parameters
###############################################################################################################################   
# Set the lower and upper bounds for all arcs
param Lower{ARCS} >=0, default 0;
param Upper{(i,j) in ARCS} >= Lower[i,j], default Infinity;

# Set all the parameters for Supply and Demand
param supply{SUPPLIERS};
param demand{MARKETS,PERIODS};
param rate{PACKMACHINE};
param packcost{PACKMACHINE};

# Do the cost tables and costs flows
param supplycost{SUPPLIERS,PACKHOUSE};
param marketcost{PACKHOUSE, MARKETS};
param Cost{ARCS} default 0;

# Set the Net Demand Node flow, ALL to specify all periods.
param NetDemand {n in NODES, p in PERIODS}
	:= if n in SUPPLIERS then -supply[n] else if n in MARKETS
	then demand[n,p];
	
###############################################################################################################################   
# Set variables
###############################################################################################################################   
# Create variables
# Four Dimensional System
var Flow {(i,j) in ARCS, t in TYPE, p in PERIODS} >= 0, integer;

# Variable to control the number of machines to build.
var Built {PACKMACHINE, PACKHOUSE, TYPE} >=0, integer;

###############################################################################################################################   
# Objective Function
###############################################################################################################################   
minimize TotalCost: sum{(i,j) in ARCS, t in TYPE, p in PERIODS} Cost[i,j]*Flow[i,j,t,p]
					+ sum{m in PACKMACHINE, h in PACKHOUSE, t in TYPE} packcost[m]*Built[m,h,t];
          
###############################################################################################################################   				
# Constraints (Try Splitting Up Contraints)
###############################################################################################################################   
# Ensure the Demand is met, meeting demand exactly
# Avocados
subject to AVMeetDemand {j in AVOCADO_DEMAND, t in TYPE, p in PERIODS}:
  sum {i in PACKHOUSE} Flow[i, j, 'AV', p] >= demand[j,p];
  
# Ensure that supply is not breached
subject to AVUseSupply {i in AVOCADO_SUPPLIERS, t in TYPE, p in PERIODS}:
  sum {j in PACKHOUSE} Flow[i ,j ,'AV' ,p] <= supply[i];

# Equal flow constraint
subject to AVConserveFlow {j in PACKHOUSE, t in TYPE, p in PERIODS}:
   sum {i in AVOCADO_SUPPLIERS} Flow[i, j, 'AV', p] = sum{i in AVOCADO_DEMAND} Flow[j, i, 'AV', p];

# Not exceed capacity at packhouse for each period
subject to AVCapacityOut {h in PACKHOUSE, t in TYPE, p in PERIODS}:
   sum {m in PACKMACHINE} Built[m, h, 'AV']*rate[m] >= sum {j in AVOCADO_SUPPLIERS} Flow[j, h, 'AV', p];

# APPLES
subject to APMeetDemand {j in APPLE_DEMAND, t in TYPE, p in PERIODS}:
  sum {i in PACKHOUSE} Flow[i, j, 'AP', p] >= demand[j,p];
  
# Ensure that supply is not breached
subject to APUseSupply {i in APPLE_SUPPLIERS, t in TYPE, p in PERIODS}:
  sum {j in PACKHOUSE} Flow[i ,j ,'AP' ,p] <= supply[i];

# Equal flow constraint
subject to APConserveFlow {j in PACKHOUSE, t in TYPE, p in PERIODS}:
   sum {i in APPLE_SUPPLIERS} Flow[i, j, 'AP', p] = sum{i in APPLE_DEMAND} Flow[j, i, 'AP', p];

# Not exceed capacity at packhouse for each period
subject to APCapacityOut {h in PACKHOUSE, t in TYPE, p in PERIODS}:
   sum {m in PACKMACHINE} Built[m, h, 'AP']*rate[m] >= sum {j in APPLE_SUPPLIERS} Flow[j, h, 'AP', p];
###############################################################################################################################   
# Model summary notes.
###############################################################################################################################   
# Splitting the model into Avocado and Apple Flows so the machine is useful
# Splitting the machines up to tell the packhouses how many of each machine to configure.
# The trick is, this is two seperate problems, avocado and apples. We want to place the packing machines in wharehouses
# that minimise the cost. Since packing machines can't be used for both apples and avocados, they are mutually exclusive.
# You can formulate into one massive problem, flicking between the avocados and apples, through all the periods.
# Don't need to take all the supply, we buy from the suppliers and incur transporation costs. We want to minimise our wastage.
# We have have contracts to buy from the suppliers.
# We might need to do a dummy demand so the problem is naturally integer.
# Model Assumption: We have a contract rate with the suppliers. We are not obligued to take all of the supply. We are not
# we are not obligued to take all of the supply, some is left over.
