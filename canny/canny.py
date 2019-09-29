import cv2 as cv
import numpy as np


def edge_canny(src, low_thresh, high_thresh):
    # 1. Noise Reduction with a Gaussian filter
    src = cv.GaussianBlur(src, ksize=(5, 5), sigmaX=0, sigmaY=0)
    h, w = src.shape[:2]
    dst = np.zeros((h, w), dtype=np.uint8)
    t_list = np.zeros((h, w))
    g_list = np.zeros((h, w))

    # 2. Finding Image Gradients
    for x in range(1, h-1):
        for y in range(1, w-1):
            # sobel kernel in the x direction
            vx = src[x-1, y-1] + 2*src[x-1, y] + src[x-1, y+1] - src[x+1, y-1] - 2*src[x+1, y] - src[x+1, y+1]
            # sobel kernel in the y direction
            vy = +src[x-1, y-1] + 2*src[x, y-1] + src[x+1, y-1] - src[x-1, y+1] - 2*src[x, y+1] - src[x+1, y+1]
            # Find magnitude
            g = int(abs(vx) + abs(vy))

            vx = vx if vx else 1.570796
            t = round(np.arctan(vy/vx)*180/np.pi)

            if t < 0:
                t += 180
            if t < 22:
                t = 0
            elif t < 67:
                t = 45
            elif t < 112:
                t = 90
            elif t < 160:
                t = 135
            elif t <= 180:
                t = 0

            g_list[x][y] = g
            t_list[x][y] = t
            # dst[x, y] = g

    #  3. Hysteresis Thresholding
    #  4. Non-maximum Suppression and output
    for x in range(1, h-1):
        for y in range(1, w-1):
            vc_t = t_list[x][y]
            vc_g = g_list[x][y]

            if vc_g < low_thresh:
                dst[x, y] = 0
                continue
            elif vc_g >= high_thresh or\
                g_list[x - 1][y - 1 ] >= high_thresh or \
                g_list[x - 1][y] >= high_thresh or \
                g_list[x - 1][y + 1] >= high_thresh or \
                g_list[x][y - 1] >= high_thresh or \
                g_list[x][y + 1] >= high_thresh or \
                g_list[x + 1][y - 1] >= high_thresh or \
                g_list[x + 1][y] >= high_thresh or \
                g_list[x + 1][y + 1] >= high_thresh:
                vc_g = vc_g
                # dst[x, y] = 255
            else:
                dst[x][y] = 0
                continue

            if vc_t == 0:
                va_g = g_list[x + 1][y]
                vb_g = g_list[x - 1][y]
            elif vc_t == 45:
                va_g = g_list[x + 1][y + 1]
                vb_g = g_list[x - 1][y - 1]
            elif vc_t == 90:
                va_g = g_list[x][y + 1]
                vb_g = g_list[x][y - 1]
            elif vc_t == 135:
                va_g = g_list[x - 1][y + 1]
                vb_g = g_list[x + 1][y - 1]
            else:
                va_g = 0
                vb_g = 0

            if not (vc_g > va_g and vc_g > vb_g):
                dst[x][y] = 0
            else:
                dst[x][y] = 255

    return dst


if __name__ == "__main__":
    im = cv.imread("dowels.tif")
    gray = cv.cvtColor(im, cv.COLOR_BGR2GRAY)
    output_img = edge_canny(gray, 150, 300)
    cv.imshow('result', output_img)
    cv.waitKey(0)


