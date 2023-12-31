###This module is an example julia-based testing interface.  It uses the
###``requests`` package to make REST API calls to the test case container,
###which mus already be running.  A controller is tested, which is
###imported from a different module.

# GENERAL PACKAGE IMPORT
# ----------------------
using HTTP, JSON, CSV, DataFrames, Dates

# TEST CONTROLLER IMPORT
# ----------------------
include("./controllers.jl")
using .sup

# SETUP TEST CASE
# ---------------
# Set URL for testcase
url = "http://127.0.0.1:5000"
length = 48 * 3600
step = 3600
# ---------------

# GET TEST INFORMATION
# --------------------
println("TEST CASE INFORMATION ------------- \n")
# Test case name
name = JSON.parse(String(HTTP.get("$url/name").body))
println("Name:\t\t\t$name")
# Inputs available
inputs = JSON.parse(String(HTTP.get("$url/inputs").body))
println("Control Inputs:\t\t\t$inputs")
# Measurements available
measurements = JSON.parse(String(HTTP.get("$url/measurements").body))
println("Measurements:\t\t\t$measurements")
# Default simulation step
step_def = JSON.parse(String(HTTP.get("$url/step").body))
println("Default Simulation Step:\t$step_def")

# RUN TEST CASE
#----------
start = Dates.now()
# Initialize test case simulation
res = HTTP.put("$url/initialize",["Content-Type" => "application/json"], JSON.json(Dict("start_time" => 0,"warmup_period" => 0)))
initialize_result=JSON.parse(String(res.body))
if !isnothing(initialize_result)
   println("Successfully initialized the simulation")
end


# Set simulation step
println("Setting simulation step to $step")
res = HTTP.put("$url/step",["Content-Type" => "application/json"], JSON.json(Dict("step" => step)))
println("Running test case ...")

# simulation loop
for i = 1:convert(Int, floor(length/step))
    if i<2
    # Initialize u
       u = sup.initialize()
    else
    # Compute next control signal
       u = sup.compute_control(y)
    end
    # Advance in simulation
    res=HTTP.post("$url/advance", ["Content-Type" => "application/json"], JSON.json(u);retry_non_idempotent=true).body
    global y = JSON.parse(String(res))
end

println("Test case complete.")
time=(now()-start).value/1000.
println("Elapsed time of test was $time seconds.")

# VIEW RESULTS
# ------------
# Report KPIs
kpi = JSON.parse(String(HTTP.get("$url/kpi").body))
println("KPI RESULTS \n-----------")
for key in keys(kpi)
   if isnothing(kpi[key])
       println("$key: nothing")
   else
       println("$key: $(kpi[key])")
   end
end

# ------------
# POST PROCESS RESULTS
# --------------------
# Get result data
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "TRooAir_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
time = [x/3600 for x in res["time"]] # convert s --> hr
TRooAir  = [x-273.15 for x in res["TRooAir_y"]] # convert K --> C
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "CO2RooAir_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
CO2RooAir  = [x for x in res["CO2RooAir_y"]]
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "oveTSetRooHea_u","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
TSetRooHea   = [x-273.15 for x in res["oveTSetRooHea_u"]] # convert K --> C
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "oveTSetRooCoo_u","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
TSetRooCoo   = [x-273.15 for x in res["oveTSetRooCoo_u"]] # convert K --> C
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "PFan_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
PFan  = res["PFan_y"]
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "PCoo_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
PCoo  = res["PCoo_y"]
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "PHea_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
PHea  = res["PHea_y"]
res = JSON.parse(String(HTTP.put("$url/results", ["Content-Type" => "application/json","connecttimeout"=>30.0], JSON.json(Dict("point_name" => "PPum_y","start_time" => 0, "final_time" => length));retry_non_idempotent=true).body))
PPum  = res["PPum_y"]
tab=DataFrame([time,TRooAir,CO2RooAir,TSetRooHea,TSetRooCoo,PFan,PCoo,PHea,PPum],[:time,:TRooAir,:CO2RooAir,:TSetRooHea,:TSetRooCoo,:PFan,:PCoo,:PHea,:PPum])
CSV.write("result_testcase2.csv",tab)
tab_kpi = DataFrame([[kpi["ener_tot"]], [kpi["tdis_tot"]], [kpi["idis_tot"]], [kpi["cost_tot"]], [kpi["time_rat"]], [kpi["emis_tot"]],[kpi["pele_tot"]]], [:ener_tot, :tdis_tot, :idis_tot, :cost_tot, :time_rat, :emis_tot, :pele_tot])
CSV.write("kpi_testcase2.csv",tab_kpi)
