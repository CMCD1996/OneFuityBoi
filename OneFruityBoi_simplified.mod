# Optimites: OneFruityBoi
# Connor McDowall 530913386 cmcd398
# Josh  Beckett 528396260 jbec200
# Alexander Zhao 619051233 azha755
# Optimisation Model File

###############################################################################################################################   
# Set all the parameters
###############################################################################################################################   
set SUPPLIERS;
set DEMAND;
set PERIODS;
set PACKMACHINE;
set PACKHOUSE;

# Create the two sets of ARCS, one for avocados, one for apples. that span the wharehouses
set ARCS:= (SUPPLIERS cross PACKHOUSE) union (PACKHOUSE cross DEMAND);
set NODES:= SUPPLIERS union PACKHOUSE union DEMAND;
###############################################################################################################################   
# Set parameters
###############################################################################################################################   
# Set the lower and upper bounds for avocado arcs
param Lower{ARCS} >=0, default 0;
param Upper{(i,j) in ARCS} >= Lower[i,j], default Infinity;

# Set all the parameters for Supply and Demand
param supply{SUPPLIERS,PERIODS};
param demand{DEMAND,PERIODS};
param rate{PACKMACHINE};
param packcost{PACKMACHINE};

# Do the cost tables and costs flows
param supplycost{SUPPLIERS,PACKHOUSE};
param marketcost{PACKHOUSE, DEMAND};
param Cost{ARCS} default 0;

# Set the Net Demand Node flow, ALL to specify all periods.
param NetDemand {n in NODES, p in PERIODS}
	:= if n in SUPPLIERS then -supply[n,p] else if n in DEMAND
	then demand[n,p];


###############################################################################################################################   
# Set variables
###############################################################################################################################   
# Create variables
# Three Dimensional
var Flow {(i,j) in ARCS, p in PERIODS} >= 0, integer;

# Variable to control the number of machines to build.
var Built {PACKMACHINE, PACKHOUSE} >=0, integer;

###############################################################################################################################   
# Objective Function
###############################################################################################################################   
minimize TotalCost: sum{(i,j) in ARCS,p in PERIODS} Cost[i,j]*Flow[i,j,p]
					+ sum{m in PACKMACHINE, h in PACKHOUSE} packcost[m]*Built[m,h];
          
###############################################################################################################################   				
# Constraints
###############################################################################################################################   
# Ensure that APPLE Demand is met, meeting demand exactly
subject to MeetDemand {j in DEMAND,p in PERIODS}:
  sum {i in PACKHOUSE} Flow[i, j, p] = demand[j,p];

# Ensure that avocado supply is not breached
subject to UseSupply {i in SUPPLIERS,p in PERIODS}:
  sum {j in PACKHOUSE} Flow[i, j, p] <= supply[i,p];
  
subject to SConserveFlow {j in SUPPLIERS,p in PERIODS}:
   sum {(i,j) in ARCS} Flow[i, j, p] - sum {(j,k) in ARCS} Flow[j, k, p] >= NetDemand[j,p];

subject to MConserveFlow {j in (DEMAND union PACKHOUSE) , p in PERIODS}:
   sum {(i,j) in ARCS} Flow[i, j, p] - sum {(j,k) in ARCS} Flow[j, k, p] >= NetDemand[j,p];
 
# Not exceed capacity at packhouse for each period (Avocados)
subject to AVCapacityOut {i in PACKHOUSE, p in PERIODS}:
   sum {m in PACKMACHINE}  Built[m, i]*rate[m] >= sum {j in DEMAND} Flow[i, j, p];



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
# 
