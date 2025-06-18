public class LoggerTest {
    public static void main(String[] args) {
       
        Logger logger1 = Logger.getInstance();
        Logger logger2 = Logger.getInstance();

       
        logger1.log("First message");
        logger2.log("Second message");

      
        if (logger1 == logger2) {
            System.out.println("Both logger instances are the same (Singleton works).");
        } else {
            System.out.println("Logger instances are different (Singleton failed).");
        }
    }
}
