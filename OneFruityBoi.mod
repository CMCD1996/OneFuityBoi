# Optimites: OneFruityBoi
# Connor McDowall 530913386 cmcd398
# Josh  Beckett 528396260 jbec200
# Alexander Zhao 619051233 azha755
# Optimisation Model File

###############################################################################################################################   
# Set all the parameters
###############################################################################################################################   
set SUPPLIERS;
set MARKETS;
set PERIODS;
set PACKMACHINE;
set PACKHOUSE;
set TYPE;

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

# Set up the Number of Periods
param numPeriods;

###############################################################################################################################   
# Set variables
###############################################################################################################################   
# Create variables
# Three Dimensional System
var Flow {(i,j) in ARCS, p in PERIODS} >= 0, integer;

# Variable to control the number of machines to build.
var Built {PACKMACHINE, PACKHOUSE} >=0, integer;

###############################################################################################################################   
# Objective Function
###############################################################################################################################   
minimize TotalCost: sum{(i,j) in ARCS, p in PERIODS} Cost[i,j]*Flow[i,j,p]
					+ sum{m in PACKMACHINE, h in PACKHOUSE} numPeriods*packcost[m]*Built[m,h];
          
###############################################################################################################################   				
# Constraints
###############################################################################################################################   
# Ensure the Demand is met, meeting demand exactly
subject to MeetDemand {j in MARKETS, p in PERIODS}:
  sum {i in PACKHOUSE} Flow[i, j, p] >= demand[j,p];
  
# Ensure that supply is not breached
subject to UseSupply {i in SUPPLIERS, p in PERIODS}:
  sum {j in PACKHOUSE} Flow[i ,j ,p] <= supply[i];

# Equal flow constraint
subject to ConserveFlow {j in PACKHOUSE, p in PERIODS}:
   sum {i in SUPPLIERS} Flow[i, j, p] = sum{i in MARKETS} Flow[j, i, p];

# Not exceed capacity at packhouse for each period
subject to CapacityOut {h in PACKHOUSE, p in PERIODS}:
   sum {m in PACKMACHINE} Built[m, h]*rate[m] >= sum {j in SUPPLIERS} Flow[j, h, p];

###############################################################################################################################   
# Model summary notes.
###############################################################################################################################   
# The model works for both Apples and Avocados
# You can treat avocados and applesas two seperate problems. Use the relevant data file for the problem.
# Avocado and Apple packing machines are mutually exclusive.
# Don't need to take all the supply, we buy from the suppliers and incur transporation costs. We want to minimise our cost and wastage.
# We have have contracts to buy from other suppliers.
# We assume the supply will not exceed the demand based on the data you have given us.
# We have deemed it not necessary to have a dummy demand.
# We have a contract rate with the suppliers. We are not obligued to take all of the supply.

