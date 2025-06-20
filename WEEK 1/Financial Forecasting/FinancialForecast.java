public class FinancialForecast {

   
    public static double calculateFutureValue(double initialValue, double growthRate, int years) {
        if (years == 0) {
            return initialValue; // base case
        }
        
        return calculateFutureValue(initialValue, growthRate, years - 1) * (1 + growthRate);
    }

    public static void main(String[] args) {
        double initialInvestment = 10000.0; // ₹10,000
        double growthRate = 0.08;           // 8% annual growth
        int years = 5;

        double futureValue = calculateFutureValue(initialInvestment, growthRate, years);
        System.out.printf("Future value after %d years: ₹%.2f\n", years, futureValue);
    }
}
