class SurvivorsPercentageReport

  INFECTED_PERCENTAGE_SQL = '
    COUNT(*) AS total,
    COUNT(*) FILTER (where infected IS TRUE) AS infected_quantity
  '.squish

  def initialize(infected:)
    @infected = infected
  end

  def calculate_infected_percentage
    result = Survivor.select(sql).load.first
    (result.infected_quantity / result.total.to_f) * 100.0
  end

  def sql
    sql_boolean = @infected ? 'TRUE' : 'FALSE'
    "COUNT(*) AS total, COUNT(*) FILTER (where infected IS #{sql_boolean}) AS infected_quantity"
  end
end