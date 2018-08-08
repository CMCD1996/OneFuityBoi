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
param avocado_demand{AVOCADO_SUPPLIERS,PERIODS};
param apple_demand{APPLE_SUPPLIERS,PERIODS};
param average_pack_rate_for_machine{PACKMACHINE};
param packing_machine_cost{PACKMACHINE};

# Do all the tables
param avocado_from_supplier_cost{AVOCADO_SUPPLIERS,PACKHOUSE};
param apple_from_supplier_cost{APPLE_SUPPLIERS,PACKHOUSE};


# Check to make sure S =  Demand creating dummy supply and demand nodes and amoiunts when necessary
