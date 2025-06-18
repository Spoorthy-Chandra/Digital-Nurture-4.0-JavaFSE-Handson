public class SearchTest {
    public static void main(String[] args) {
        Product[] products = {
            new Product(101, "Laptop", "Electronics"),
            new Product(102, "Shoes", "Fashion"),
            new Product(103, "Book", "Education"),
            new Product(104, "Headphones", "Electronics"),
            new Product(105, "Watch", "Fashion")
        };

      
        Product result1 = SearchUtil.linearSearch(products, "Book");
        System.out.println("Linear Search Result: " + (result1 != null ? result1 : "Not Found"));

       
        SearchUtil.sortProductsByName(products);

       
        Product result2 = SearchUtil.binarySearch(products, "Book");
        System.out.println("Binary Search Result: " + (result2 != null ? result2 : "Not Found"));
    }
}
