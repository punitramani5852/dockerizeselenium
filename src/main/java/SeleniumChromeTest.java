import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

import static java.lang.System.getProperty;

public class SeleniumChromeTest {
    public static void main(String[] args){
    System.setProperty("webdriver.chrome.driver",getProperty("user.dir") + "/DriverFiles/chromedriver");

        //Setting up the driver and giving the pth to the driver file
        WebDriver driver = new ChromeDriver();
        //Initialize the driver

        driver.get("https://google.in");
        //Hitting the URL you want to test
        driver.getTitle();
        //Get the title of the page
        System.out.println(driver.getTitle());
        //printing the title of the page on the console
        System.out.println(driver.getCurrentUrl());
        //Printing the URL for verifying that we have hit the correct URL

        driver.close();
        // To close window that has the focus

    }
}
