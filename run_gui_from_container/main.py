import cv2
cv2.namedWindow("Show")
img = cv2.imread("test.jpg")
img = cv2.resize(img, (540,320))
cv2.imshow("Show", img)
cv2.waitKey(0)
cv2.destroyAllWindows()
