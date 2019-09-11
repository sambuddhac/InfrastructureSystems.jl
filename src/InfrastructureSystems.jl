module InfrastructureSystems

import CSV
import DataFrames
import Dates
import JSON
import JSON2
import TimeSeries

export Component
export Components
export FlattenIteratorWrapper
export Forecasts
export InfrastructureSystemsInternal
export InfrastructureSystemsType
export SystemData
export TimeseriesFileMetadata

export Forecast
export Deterministic
export Probabilistic
export ScenarioBased

export get_name
export open_file_logger

# Components functions
export iterate_components
export add_component!
export remove_components!
export remove_component!
export get_component
export get_components_by_name
export get_components

# Forecasts functions
export add_forecasts!
export add_forecast!
export remove_forecast!
export clear_forecasts!
export get_forecast_initial_times
export get_forecasts
export get_forecasts_horizon
export get_forecasts_initial_time
export get_forecasts_interval
export get_forecasts_resolution
export get_forecast_component_name
export get_forecast_value
export get_timeseries
export iterate_forecasts
export make_forecasts
export split_forecasts!
export read_timeseries_metadata

export runtests

# Every subtype must implement get_name().
# TODO: how to document interface formally?
abstract type InfrastructureSystemsType end

# TODO: not correct, just a placeholder
get_name(value::InfrastructureSystemsType) = value.name

abstract type Component <: InfrastructureSystemsType end

include("common.jl")
include("internal.jl")
include("utils/flatten_iterator_wrapper.jl")
include("utils/lazy_dict_from_iterator.jl")
include("utils/logging.jl")
include("utils/utils.jl")

include("components.jl")
include("forecasts.jl")
include("forecast_parser.jl")
include("generated/includes.jl")
include("supplemental_constructors.jl")
include("supplemental_accessors.jl")
include("timeseries_formats.jl")
include("serialization.jl")
include("system_data.jl")
include("test.jl")

end # module
