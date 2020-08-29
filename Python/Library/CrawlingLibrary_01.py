from selenium import webdriver
options = webdriver.ChromeOptions()
options.add_argument('headless') #백그라운드 실행 옵션
driver = webdriver.Chrome(r'C:\Users\pkuuu\PycharmProjects\TestPj\chromedriver', chrome_options=options)
driver.set_window_size(800,1600) #창 크기 조절
driver.get('https://www.naver.com/')
driver.implicitly_wait(3)
print(driver.title) #제목 출력


# driver.get_screenshot_as_file('naver_Main_headless.png')
# driver.quit()
