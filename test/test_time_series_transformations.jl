function test_inner_round_trip_common(
    data::Union{Vector{T}, SortedDict{Dates.DateTime, <:Vector{T}}},
    compare_to,
) where {T}
    transformed = IS.transform_array_for_hdf(data)
    retransformed = IS.retransform_hdf_array(transformed, T)
    @test size(retransformed) == size(compare_to)  # redundant but a more informative failure
    @test retransformed == compare_to
end

test_inner_round_trip(data::Vector) = test_inner_round_trip_common(data, data)

test_inner_round_trip(data::SortedDict{Dates.DateTime, <:Vector}) =
    test_inner_round_trip_common(data, hcat(values(data)...))

@testset "Test transform_array_for_hdf -> retransform_hdf_array round trip" begin
    test_dates = [Dates.DateTime("2023-01-01"), Dates.DateTime("2024-01-01")]
    gen_piecewise_linear(start, n) = [
        IS.PiecewiseLinearData([(i, i + 1), (i + 2, i + 3), (i + 4, i + 5)])
        for i::Float64 in start:6:(start + 6 * (n - 1))]
    test_datas_1 = [
        [1.0, 2.0, 3.0],
        [
            IS.LinearFunctionData(1.0),
            IS.LinearFunctionData(2.0),
            IS.LinearFunctionData(3.0),
        ],
        [
            IS.LinearFunctionData(1.0, 7.0),
            IS.LinearFunctionData(2.0, 8.0),
            IS.LinearFunctionData(3.0, 9.0),
        ],
        [
            IS.QuadraticFunctionData(1.0, 2.0, 3.0),
            IS.QuadraticFunctionData(4.0, 5.0, 6.0),
            IS.QuadraticFunctionData(7.0, 8.0, 9.0),
            IS.QuadraticFunctionData(10.0, 11.0, 12.0),
        ],
        gen_piecewise_linear(0, 4),
    ]
    test_datas_2 = [
        [4.0, 5.0, 6.0],
        [
            IS.LinearFunctionData(4.0),
            IS.LinearFunctionData(5.0),
            IS.LinearFunctionData(6.0),
        ],
        [
            IS.LinearFunctionData(1.0, 10.0),
            IS.LinearFunctionData(2.0, 11.0),
            IS.LinearFunctionData(3.0, 12.0),
        ],
        [
            IS.QuadraticFunctionData(21.0, 22.0, 23.0),
            IS.QuadraticFunctionData(24.0, 25.0, 26.0),
            IS.QuadraticFunctionData(27.0, 28.0, 29.0),
            IS.QuadraticFunctionData(30.0, 31.0, 32.0),
        ],
        gen_piecewise_linear(50, 4),
    ]
    test_datas_dated = [
        SortedDict{Dates.DateTime, typeof(data_1)}(
            test_dates[1] => data_1, test_dates[2] => data_2)
        for (data_1, data_2) in zip(test_datas_1, test_datas_2)]
    for test_data in test_datas_1
        test_inner_round_trip(test_data)
    end
    for test_data in test_datas_dated
        test_inner_round_trip(test_data)
    end
end
