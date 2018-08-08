# Optimites: OneFruityBoi
# Connor McDowall 530913386 cmcd398
# Josh  Beckett
# Alexander Zhao 
# Optimisation Model File
# Set all the parameters
set AVOCADO_SUPPLIERS;
set APPLE_SUPPLIERS;
set AVOCADO_MARKET_PERIOD_1;
set AVOCADO_MARKET_PERIOD_2;
set AVOCADO_MARKET_PERIOD_3;
set AVOCADO_MARKET_PERIOD_4;
set AVOCADO_MARKET_PERIOD_5;
set AVOCADO_MARKET_PERIOD_6;
set AVOCADO_MARKET_PERIOD_7;
set AVOCADO_MARKET_PERIOD_8;
set AVOCADO_MARKET_PERIOD_9;
set AVOCADO_MARKET_PERIOD_10;
set APPLE_MARKET_PERIOD_1;
set APPLE_MARKET_PERIOD_2;
set APPLE_MARKET_PERIOD_3;
set APPLE_MARKET_PERIOD_4;
set APPLE_MARKET_PERIOD_5;
set APPLE_MARKET_PERIOD_6;
set APPLE_MARKET_PERIOD_7;
set APPLE_MARKET_PERIOD_8;
set APPLE_MARKET_PERIOD_9;
set APPLE_MARKET_PERIOD_10;
set PACKMACHINE;
set PACKHOUSE;

# Set all the parameters
param avocado_supply{AVOCADO_SUPPLIERS};
param apple_supply{APPLE_SUPPLIERS};
param avocado_demand_period_1{AVOCADO_MARKET_PERIOD_1};
param avocado_demand_period_2{AVOCADO_MARKET_PERIOD_2};
param avocado_demand_period_3{AVOCADO_MARKET_PERIOD_3};
param avocado_demand_period_4{AVOCADO_MARKET_PERIOD_4};
param avocado_demand_period_5{AVOCADO_MARKET_PERIOD_5};
param avocado_demand_period_6{AVOCADO_MARKET_PERIOD_6};
param avocado_demand_period_7{AVOCADO_MARKET_PERIOD_7};
param avocado_demand_period_8{AVOCADO_MARKET_PERIOD_8};
param avocado_demand_period_9{AVOCADO_MARKET_PERIOD_9};
param avocado_demand_period_10{AVOCADO_MARKET_PERIOD_10};
param apple_demand_period_1{APPLE_MARKET_PERIOD_1};
param apple_demand_period_2{APPLE_MARKET_PERIOD_2};
param apple_demand_period_3{APPLE_MARKET_PERIOD_3};
param apple_demand_period_4{APPLE_MARKET_PERIOD_4};
param apple_demand_period_5{APPLE_MARKET_PERIOD_5};
param apple_demand_period_6{APPLE_MARKET_PERIOD_6};
param apple_demand_period_7{APPLE_MARKET_PERIOD_7};
param apple_demand_period_8{APPLE_MARKET_PERIOD_8};
param apple_demand_period_9{APPLE_MARKET_PERIOD_9};
param apple_demand_period_10{APPLE_MARKET_PERIOD_10};
param average_pack_rate_for_machine{PACKMACHINE};
param packing_machine_cost{PACKMACHINE};

# Do all the tables
param avocado_from_supplier_cost{AVOCADO_SUPPLIERS,PACKHOUSE};
param apple_from_supplier_cost{APPLE_SUPPLIERS,PACKHOUSE};

param avocado_to_market_P1{PACKHOUSE,AVOCADO_MARKET_PERIOD_1};
param avocado_to_market_P2{PACKHOUSE,AVOCADO_MARKET_PERIOD_2};
param avocado_to_market_P3{PACKHOUSE,AVOCADO_MARKET_PERIOD_3};
param avocado_to_market_P4{PACKHOUSE,AVOCADO_MARKET_PERIOD_4};
param avocado_to_market_P5{PACKHOUSE,AVOCADO_MARKET_PERIOD_5};
param avocado_to_market_P6{PACKHOUSE,AVOCADO_MARKET_PERIOD_6};
param avocado_to_market_P7{PACKHOUSE,AVOCADO_MARKET_PERIOD_7};
param avocado_to_market_P8{PACKHOUSE,AVOCADO_MARKET_PERIOD_8};
param avocado_to_market_P9{PACKHOUSE,AVOCADO_MARKET_PERIOD_9};
param avocado_to_market_P10{PACKHOUSE,AVOCADO_MARKET_PERIOD_10}

param apple_to_market_P1{PACKHOUSE,APPLE_MARKET_PERIOD_1};
param apple_to_market_P2{PACKHOUSE,APPLE_MARKET_PERIOD_2};
param apple_to_market_P3{PACKHOUSE,APPLE_MARKET_PERIOD_3};
param apple_to_market_P4{PACKHOUSE,APPLE_MARKET_PERIOD_4};
param apple_to_market_P5{PACKHOUSE,APPLE_MARKET_PERIOD_5};
param apple_to_market_P6{PACKHOUSE,APPLE_MARKET_PERIOD_6};
param apple_to_market_P7{PACKHOUSE,APPLE_MARKET_PERIOD_7};
param apple_to_market_P8{PACKHOUSE,APPLE_MARKET_PERIOD_8};
param apple_to_market_P9{PACKHOUSE,APPLE_MARKET_PERIOD_9};
param apple_to_market_P10{PACKHOUSE,APPLE_MARKET_PERIOD_10};


# Check to make sure S =  Demand creating dummy supply and demand nodes and amoiunts when necessary