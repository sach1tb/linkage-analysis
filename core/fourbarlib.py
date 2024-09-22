import matplotlib.pyplot as plt
import numpy as np

def fourbar_plot(a,b,c,d,t1,t2,t3,t4,phi,ap):
    Rz=np.array([0,0])
    if np.isscalar(t1):
        t1=t1 + t2*0


    Ra=np.array([a*np.cos(t2), a*np.sin(t2)])
    Rb=np.array([b*np.cos(t3), b*np.sin(t3)]) + Ra
    Rp=np.array([ap*np.cos(t3+phi), ap*np.sin(t3+phi)]) + Ra
    Ry=np.array([c*np.cos(t1), d*np.sin(t1)])


    # plot everything
    fig, ax = plt.subplots(figsize=(8,8))

    # d
    plt.plot([Rz[0], Ry[0]], [Rz[1], Ry[1]],'k-s', linewidth=2, markersize=12)
    # a
    plt.plot([Rz[0], Ra[0]], [Rz[1], Ra[1]],'r-o')
    # b
    plt.plot([Ra[0], Rb[0]], [Ra[1], Rb[1]],'k--o')
    plt.plot([Ra[0], Rp[0]], [Ra[1], Rp[1]],'g-o')
    plt.plot([Rp[0], Rb[0]], [Rp[1], Rb[1]],'g-o')
    plt.plot([Ra[0], Ra[0]+b], [Ra[1], Ra[1]],'k:')
    angle = "%0.2f"%float(t3*180/np.pi)+u"\u00b0"
    plt.text(Ra[0]+b/20, Ra[1]+b/20, r'$\theta_3=$ '+angle)
    # c
    plt.plot([Rb[0], Ry[0]], [Rb[1], Ry[1]],'b-o')
    plt.show()