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

# Set all the parameters for Supply and Demand
param avocado_supply{AVOCADO_SUPPLIERS};
param apple_supply{APPLE_SUPPLIERS};
param avocado_demand{AVOCADO_MARKET,PERIODS};
param apple_demand{APPLE_MARKET,PERIODS};
param average_pack_rate_for_machine{PACKMACHINE};
param packing_machine_cost{PACKMACHINE};

# temp for a simplified model
param simple_avocado_demand {AVOCADO_MARKET};

# Do all the tables
param avocado_from_supplier_cost{AVOCADO_SUPPLIERS,PACKHOUSE};
param apple_from_supplier_cost{PACKHOUSE, APPLE_SUPPLIERS};

# Check to make sure S =  Demand creating dummy supply and demand nodes and amoiunts when necessary

var Build {} >=0, integer

# Constraints
# Ensure that Demand is met
subject to MeetDemand {j in AVOCADO_MARKET}:
  sum {i in PACKHOUSE} Flow[i, j] >= simple_avocado_demand[j]

# Ensure that supply is not breached
subject to UseSupply {i in AVOCADO_SUPPLIERS}:
  sum {j in PACKHOUSE} Flow[i, j] <= avocado_supply[i]

# Must conserve flow at the packhouses
subject to ConserveFlow {i in PACKHOUSE}:
   sum {j in AVOCADO_SUPPLIERS} Flow[j,i]= sum {j in AVOCADO_MARKET} Flow[i,j];

# Not exceed capacity at packhouse <-- THIS ONE NEEDS TO BE FIXED
subject to Capacity {i in PACKHOUSE}:
   sum {p in PACKMACHINE, }  Build[]*Capacity[p]>= sum {j in AVOCADO_MARKET} Flow[i, j];

