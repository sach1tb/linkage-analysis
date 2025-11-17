// fourbar
const fb_canvas = document.getElementById('fb_canvas');
const fb_ctx = fb_canvas.getContext('2d');

// crank slider
const cs_canvas = document.getElementById('cs_canvas');
const cs_ctx = cs_canvas.getContext('2d');

// slider crank
const scr_canvas = document.getElementById('scr_canvas');
const scr_ctx = scr_canvas.getContext('2d');

// inverted crank slider
const ics_canvas = document.getElementById('ics_canvas');
const ics_ctx = ics_canvas.getContext('2d');

// inverted slider crank
const iscr_canvas = document.getElementById('iscr_canvas');
const iscr_ctx = iscr_canvas.getContext('2d');

// Flip the y-axis
//fb_ctx.scale(1, -1);
//fb_ctx.transform(1, 0, 0, -1, 0, fb_canvas.height)

let scale = 1;
let originX = 0;
let originY = 0;

// Get slider elements
// fourbar
const fb_groundSlider = document.getElementById('fb_ground');
const fb_couplerSlider = document.getElementById('fb_coupler');
const fb_APSlider = document.getElementById('fb_APlen');
const fb_BAPSlider = document.getElementById('fb_BAPAngle');
const fb_outputSlider = document.getElementById('fb_output');
const fb_crankSlider = document.getElementById('fb_crank');
const fb_crankAngleSlider = document.getElementById('fb_crankA');
const fb_groundAngleSlider = document.getElementById('fb_groundA');
const fb_configCheckbox = document.getElementById('fb_config');
//const playButton = document.getElementById('playButton');

// crank slider
const cs_couplerSlider = document.getElementById('cs_coupler');
const cs_crankSlider = document.getElementById('cs_crank');
const cs_offsetSlider = document.getElementById('cs_offset');
const cs_crankAngleSlider = document.getElementById('cs_crankA');
const cs_configCheckbox = document.getElementById('cs_config');

// slider crank
const scr_couplerSlider = document.getElementById('scr_coupler');
const scr_crankSlider = document.getElementById('scr_crank');
const scr_offsetSlider = document.getElementById('scr_offset');
const scr_slider_distance_slider = document.getElementById('scr_slider_distance_slider');
const scr_configCheckbox = document.getElementById('scr_config');

// inverted crank slider
const ics_crank_slider = document.getElementById('ics_crank_slider');
const ics_gammaSlider = document.getElementById('ics_gammaSlider');
const ics_groundSlider = document.getElementById('ics_groundSlider');
const ics_outputSlider = document.getElementById('ics_outputSlider');
const ics_crankAngleSlider = document.getElementById('ics_crankAngleSlider');
const ics_configCheckBox = document.getElementById('ics_configCheckBox');
//document.getElementById("ics_configCheckBox").disabled = true


// inverted slider crank
const iscr_crank_slider = document.getElementById('iscr_crank_slider');
const iscr_gammaSlider = document.getElementById('iscr_gammaSlider');
const iscr_groundSlider = document.getElementById('iscr_groundSlider');
const iscr_outputSlider = document.getElementById('iscr_outputSlider');
const iscr_coupler_length_slider = document.getElementById('iscr_coupler_length_slider');
const iscr_configCheckBox = document.getElementById('iscr_configCheckBox');
//document.getElementById("iscr_configCheckBox").disabled = true

// fourbar
//let isPlaying = false;
//let ground_angle = fb_groundAngleSlider.value*Math.PI/180; // Starting angle for the rotation
//let crank_angle = fb_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation

// crank slider
//let cs_crank_angle = cs_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation


// Display initial values
// fourbar
document.getElementById('fb_groundLength').innerText = fb_groundSlider.value;
document.getElementById('fb_couplerLength').innerText = fb_couplerSlider.value;
document.getElementById('fb_APLength').innerText = fb_APSlider.value;
document.getElementById('fb_BAP').innerText = fb_BAPSlider.value;
document.getElementById('fb_outputLength').innerText = fb_outputSlider.value;
document.getElementById('fb_crankLength').innerText = fb_crankSlider.value;
document.getElementById('fb_crankA').innerText = fb_crankAngleSlider.value;
document.getElementById('fb_groundA').innerText = fb_groundAngleSlider.value;

// crank slider
document.getElementById('cs_couplerLength').innerText = cs_couplerSlider.value;
document.getElementById('cs_crankLength').innerText = cs_crankSlider.value;
document.getElementById('cs_offsetHeight').innerText = cs_offsetSlider.value;
document.getElementById('cs_crankAngleSlider').innerText = cs_crankAngleSlider.value;

// slider crank
document.getElementById('scr_couplerLength').innerText = scr_couplerSlider.value;
document.getElementById('scr_crankLength').innerText = scr_crankSlider.value;
document.getElementById('scr_offsetHeight').innerText = scr_offsetSlider.value;
document.getElementById('scr_slider_distance').innerText = scr_slider_distance_slider.value;

// inverted crank slider
document.getElementById('ics_groundLength').innerText = ics_groundSlider.value;
document.getElementById('ics_crank_length').innerText = ics_crank_slider.value;
document.getElementById('ics_outputLength').innerText = ics_outputSlider.value;
document.getElementById('ics_crankAngleSlider').innerText = ics_crankAngleSlider.value;
document.getElementById('ics_gammaSlider').innerText = ics_gammaSlider.value;

// inverted slider crank
document.getElementById('iscr_groundLength').innerText = iscr_groundSlider.value;
document.getElementById('iscr_crank_length').innerText = iscr_crank_slider.value;
document.getElementById('iscr_outputLength').innerText = iscr_outputSlider.value;
document.getElementById('iscr_coupler_length').innerText = iscr_coupler_length_slider.value;
document.getElementById('iscr_gammaSlider').innerText = iscr_gammaSlider.value;

// Event listeners to update the display and redraw
// fourbar
fb_groundSlider.oninput = () => updateDisplay(fb_groundSlider, 'fb_groundLength');
fb_couplerSlider.oninput = () => updateDisplay(fb_couplerSlider, 'fb_couplerLength');
fb_APSlider.oninput = () => updateDisplay(fb_APSlider, 'fb_APLength');
fb_BAPSlider.oninput = () => updateDisplay(fb_BAPSlider, 'fb_BAP');
fb_outputSlider.oninput = () => updateDisplay(fb_outputSlider, 'fb_outputLength');
fb_crankSlider.oninput = () => updateDisplay(fb_crankSlider, 'fb_crankLength');
fb_crankAngleSlider.oninput = () => updateDisplay(fb_crankAngleSlider, 'fb_crankAngleSlider');
fb_groundAngleSlider.oninput = () => updateDisplay(fb_groundAngleSlider, 'fb_groundAngleSlider');

// crank slider
cs_crankSlider.oninput = () => updateDisplay(cs_crankSlider, 'cs_crankLength');
cs_offsetSlider.oninput = () => updateDisplay(cs_offsetSlider, 'cs_offsetHeight');
cs_crankAngleSlider.oninput = () => updateDisplay(cs_crankAngleSlider, 'cs_crankAngleSlider');
cs_couplerSlider.oninput = () => updateDisplay(cs_couplerSlider, 'cs_couplerLength');

// slider crank
scr_crankSlider.oninput = () => updateDisplay(scr_crankSlider, 'scr_crankLength');
scr_offsetSlider.oninput = () => updateDisplay(scr_offsetSlider, 'scr_offsetHeight');
scr_slider_distance_slider.oninput = () => updateDisplay(scr_slider_distance_slider, 'scr_slider_distance');
scr_couplerSlider.oninput = () => updateDisplay(scr_couplerSlider, 'scr_couplerLength');

// inverted crank slider
ics_groundSlider.oninput = () => updateDisplay(ics_groundSlider, 'ics_groundLength');
ics_crank_slider.oninput = () => updateDisplay(ics_crank_slider, 'ics_crank_length');
ics_outputSlider.oninput = () => updateDisplay(ics_outputSlider, 'ics_outputLength');
ics_crankAngleSlider.oninput = () => updateDisplay(ics_crankAngleSlider, 'ics_crankAngle');
ics_gammaSlider.oninput = () => updateDisplay(ics_gammaSlider, 'ics_gammaAngle');

// inverted slider crank
iscr_groundSlider.oninput = () => updateDisplay(iscr_groundSlider, 'iscr_groundLength');
iscr_crank_slider.oninput = () => updateDisplay(iscr_crank_slider, 'iscr_crank_length');
iscr_outputSlider.oninput = () => updateDisplay(iscr_outputSlider, 'iscr_outputLength');
iscr_coupler_length_slider.oninput = () => updateDisplay(iscr_coupler_length_slider, 'iscr_coupler_length');
iscr_gammaSlider.oninput = () => updateDisplay(iscr_gammaSlider, 'iscr_gammaAngle');

// zoom -- commenting because it doesn't work very well on smart devices
// and the coupler curve plot looks funny
// fb_canvas.addEventListener("wheel", function (e) {
//     e.preventDefault();
//     const delta = e.deltaY < 0 ? 1.01 : 0.99;
//     const rect = fb_canvas.getBoundingClientRect();
//     const x = e.clientX - rect.left;
//     const y = e.clientY - rect.top;

//     // Zoom towards the mouse cursor

//     originX = x - (x - originX) * delta;
//     originY = y - (y - originY) * delta;
//     scale *= delta;

//     drawFourBar();
// });


// configuration change
// fourbar
fb_config.addEventListener("change", function () {
    drawFourBar();
});

// crank slider
cs_config.addEventListener("change", function () {
    drawCrankSlider();
});

// slider crank
scr_config.addEventListener("change", function () {
    drawSliderCrank();
});

// inverted crank slider
ics_configCheckBox.addEventListener("change", function () {
    draw_inv_crank_slider();
});

// inverted crank slider
iscr_configCheckBox.addEventListener("change", function () {
    draw_inv_slider_crank();
});

// curve plotting
// fourbar
fb_plot_curve_button.onclick = () => {
    drawCouplerCurve()
};


// link lengths
fb_2x_link_lengths.onclick = () => {
    const fb_sliders = [document.getElementById('fb_ground'),
    document.getElementById('fb_APlen'),
    document.getElementById('fb_coupler'),
    document.getElementById('fb_crank'),
    document.getElementById('fb_output')];

    fb_sliders.forEach(slider => {
        // Do something with each slider, e.g., change its value
        slider.value = slider.value * 2;
    });

    document.getElementById('fb_couplerLength').innerText = fb_couplerSlider.value;
    document.getElementById('fb_APLength').innerText = fb_APSlider.value;
    document.getElementById('fb_outputLength').innerText = fb_outputSlider.value;
    document.getElementById('fb_crankLength').innerText = fb_crankSlider.value;
    document.getElementById('fb_groundLength').innerText = fb_groundSlider.value;
    drawFourBar();
};

fb_p5x_link_lengths.onclick = () => {
    const fb_sliders = [document.getElementById('fb_ground'),
    document.getElementById('fb_APlen'),
    document.getElementById('fb_coupler'),
    document.getElementById('fb_crank'),
    document.getElementById('fb_output')];

    fb_sliders.forEach(slider => {
        // Do something with each slider, e.g., change its value
        slider.value = slider.value / 2;
    });

    document.getElementById('fb_couplerLength').innerText = fb_couplerSlider.value;
    document.getElementById('fb_APLength').innerText = fb_APSlider.value;
    document.getElementById('fb_outputLength').innerText = fb_outputSlider.value;
    document.getElementById('fb_crankLength').innerText = fb_crankSlider.value;
    document.getElementById('fb_groundLength').innerText = fb_groundSlider.value;
    drawFourBar();
};

// playButton.onclick = () => {
//     isPlaying = !isPlaying;
//     playButton.innerText = isPlaying ? 'Pause' : 'Play';
//     if (isPlaying) {
//         animate();
//     }
// };

// Initial draw
drawFourBar();
drawCrankSlider();
drawSliderCrank();
draw_inv_crank_slider();
draw_inv_slider_crank();

function openPage(pageName, elmnt) {
    // Hide all elements with class="tabcontent" by default */
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Remove the background color of all tablinks/buttons
    // tablinks = document.getElementsByClassName("tablink");
    //for (i = 0; i < tablinks.length; i++) {
    //  tablinks[i].style.backgroundColor = "";
    //}

    // Show the specific tab content
    document.getElementById(pageName).style.display = "block";

}

// Get the element with id="defaultOpen" and click on it
document.getElementById("defaultOpen").click();

function updateDisplay(slider, valueId) {
    document.getElementById(valueId).innerText = slider.value;

    drawFourBar();
    drawCrankSlider();
    drawSliderCrank();
    draw_inv_crank_slider();
    draw_inv_slider_crank();
}

function fourbar_position(a, b, c, d, t2, t1, cfg) {
    const K1 = 2 * d * c * Math.cos(t1) - 2 * a * c * Math.cos(t2);
    const K2 = 2 * d * c * Math.sin(t1) - 2 * a * c * Math.sin(t2);
    const K3 = 2 * a * d * Math.sin(t1) * Math.sin(t2) + 2 * a * d * Math.cos(t1) * Math.cos(t2);
    const K4 = b ** 2 - a ** 2 - c ** 2 - d ** 2;

    const A = K4 + K1 + K3;
    const B = -2 * K2;
    const C = K4 - K1 + K3;

    const t4c = 2 * Math.atan((-B - Math.sqrt(B ** 2 - 4 * A * C)) / (2 * A));
    const t4o = 2 * Math.atan((-B + Math.sqrt(B ** 2 - 4 * A * C)) / (2 * A));

    const K5 = 2 * a * b * Math.cos(t2) - 2 * b * d * Math.cos(t1);
    const K6 = 2 * a * b * Math.sin(t2) - 2 * b * d * Math.sin(t1);
    const K7 = 2 * a * d * Math.sin(t1) * Math.sin(t2) + 2 * a * d * Math.cos(t1) * Math.cos(t2);
    const K8 = (c ** 2 - d ** 2 - a ** 2 - b ** 2);


    const D = K8 + K7 + K5;
    const E = -2 * K6;
    const F = K8 - K5 + K7;


    const t3c = 2 * Math.atan((-E + Math.sqrt(E ** 2 - 4 * D * F)) / (2 * D));
    const t3o = 2 * Math.atan((-E - Math.sqrt(E ** 2 - 4 * D * F)) / (2 * D));

    if (cfg == 1) {
        t3 = t3o;
        t4 = t4o;
    } else {
        t3 = t3c;
        t4 = t4c;
    }
    return [t3, t4]
}

function cs_position(a, b, c, t2, cfg) {
    t31 = Math.asin((a * Math.sin(t2) - c) / b);
    t32 = Math.PI - t31;
    if (cfg == 1) {
        t3 = t31;
    } else {
        t3 = t32;
    }
    d = a * Math.cos(t2) - b * Math.cos(t3);
    return [t3, d]
}

function scr_position(a, b, c, d, cfg) {
    K1 = a ** 2 - b ** 2 + c ** 2 + d ** 2;
    K2 = -2 * a * c;
    K3 = -2 * a * d;

    A = K1 - K3;
    B = 2 * K2;
    C = K1 + K3;

    if (A == 0) { A = Number.EPSILON }
    t21 = 2 * Math.atan((-B + Math.sqrt(B ** 2 - 4 * A * C)) / (2 * A));
    t22 = 2 * Math.atan((-B - Math.sqrt(B ** 2 - 4 * A * C)) / (2 * A));

    t31 = Math.PI - Math.asin(1. / b * (a * Math.sin(t21) - c));
    t32 = Math.PI - Math.asin(1. / b * (a * Math.sin(t22) - c));

    if (cfg == 1) {
        t2 = t21;
        t3 = t31;
    } else {
        t2 = t22;
        t3 = t32;
    }
    return [t2, t3]

}

function ics_position(a, c, d, gamma, t2, cfg) {
    P = a * Math.sin(t2) * Math.sin(gamma) + (a * Math.cos(t2) - d) * Math.cos(gamma);
    Q = -a * Math.sin(t2) * Math.cos(gamma) + (a * Math.cos(t2) - d) * Math.sin(gamma);
    R = -c * Math.sin(gamma);

    S = R - Q;
    T = 2 * P;
    U = Q + R;

    t41 = 2 * Math.atan2((-T + Math.sqrt(T ** 2 - 4 * S * U)), (2 * S));
    t42 = 2 * Math.atan2((-T - Math.sqrt(T ** 2 - 4 * S * U)), (2 * S));

    t31 = t41 + gamma;
    t32 = t42 + gamma;

    b1 = (a * Math.sin(t2) - c * Math.sin(t41)) / (Math.sin(t31));
    b2 = (a * Math.sin(t2) - c * Math.sin(t42)) / (Math.sin(t32));
    //b2=Math.abs(b2);

    if (cfg == 1) {
        t3 = t31;
        t4 = t41;
        b = b1;
    } else {
        t3 = t32;
        t4 = t42;
        b = b2;
    }
    //d=a*Math.cos(t2)-b*Math.cos(t3);
    return [t3, t4, b]

}


function iscr_position(a, b, c, d, gamma, cfg) {
    K1 = a**2 -d**2-c**2-b**2-2*b*c*Math.cos(gamma);
    K2 = 2*d;
    
    F = -K2*c - K1 - K2*b*Math.cos(gamma);
    G = -K2*b*2*Math.sin(gamma);
    H = K2*c + K2*b*Math.cos(gamma) - K1;


    t41 = 2 * Math.atan2((-G + Math.sqrt(G**2 - 4 * F * H)), (2 * F));
    t42 = 2 * Math.atan2((-G - Math.sqrt(G**2 - 4 * F * H)), (2 * F));

    if (cfg == 1) {
        t4 = t41;
    } else {
        t4 = t42;
    }

    t3=t4+gamma;
    tx=(d+c*Math.cos(t4)+b*Math.cos(t3));
    ty=(c*Math.sin(t4)+b*Math.sin(t3));
    t2=Math.atan2(ty,tx);
    // t2=(Math.asin((c*Math.sin(t4)+b*Math.sin(t3))/a));
    //d=a*Math.cos(t2)-b*Math.cos(t3);
    return [t2, t3, t4]

}


function drawCouplerCurve() {
    const ground = parseInt(fb_groundSlider.value);
    const coupler = parseInt(fb_couplerSlider.value);
    const output = parseInt(fb_outputSlider.value);
    const crank = parseInt(fb_crankSlider.value);
    const ground_angle = parseInt(fb_groundAngleSlider.value) * Math.PI / 180; // Starting angle for the rotation

    // Fixed point (Z)
    const Z = { x: 100, y: 100 };
    let cfg = 0;
    if (fb_configCheckbox.checked) {
        cfg = 1;
    }
    for (var iter = 0; iter < 500; iter++) {
        t2 = iter * 2 * Math.PI / 500;
        const angles = fourbar_position(crank, coupler, output, ground,
            t2, ground_angle, cfg)
        const P = {
            x: Z.x + crank * Math.cos(t2) + fb_APSlider.value * Math.cos(fb_BAPSlider.value * Math.PI / 180 + angles[0]),
            y: Z.y + crank * Math.sin(t2) + fb_APSlider.value * Math.sin(fb_BAPSlider.value * Math.PI / 180 + angles[0])
        };
        P.y = fb_canvas.height - P.y;
        fb_ctx.fillRect(P.x, P.y, 1, 1);
    }
}

function drawFourBar() {

    // check if the link lengths are stretchable
    const fb_sliders = [document.getElementById('fb_ground'),
    document.getElementById('fb_APlen'),
    document.getElementById('fb_coupler'),
    document.getElementById('fb_crank'),
    document.getElementById('fb_output')];
    // can we stretch them
    fb_stretch = 1;
    fb_sliders.forEach(slider => {
        if (slider.value > slider.max / 2) {
            fb_stretch = 0;
        }
    });
    if (fb_stretch == 1) {
        document.getElementById('fb_2x_link_lengths').disabled = false;
    }
    else {
        document.getElementById('fb_2x_link_lengths').disabled = true;
    };

    // can we reduce the length
    fb_contract = 1;
    fb_sliders.forEach(slider => {
        if (slider.value/2 < slider.min*2) {
            fb_contract = 0;
        }
    });
    if (fb_contract == 1) {
        document.getElementById('fb_p5x_link_lengths').disabled = false;
    }
    else {
        document.getElementById('fb_p5x_link_lengths').disabled = true;
    };


    const ground = parseInt(fb_groundSlider.value);
    const coupler = parseInt(fb_couplerSlider.value);
    const output = parseInt(fb_outputSlider.value);
    const crank = parseInt(fb_crankSlider.value);
    const crank_angle = parseInt(fb_crankAngleSlider.value) * Math.PI / 180; // Starting angle for the rotation
    const ground_angle = parseInt(fb_groundAngleSlider.value) * Math.PI / 180; // Starting angle for the rotation

    //if (animate){
    //    const crank_angle = parseInt(fb_crankAngleSlider.value)*Math.PI/180;
    //}
    // Clear the fb_canvas
    fb_ctx.clearRect(0, 0, fb_canvas.width, fb_canvas.height);
    //drawCouplerCurve();
    fb_ctx.save();
    fb_ctx.translate(originX, originY);
    fb_ctx.scale(scale, scale);

    // Draw your content here
    // Fixed point (Z)
    const Z = { x: 100, y: 100 };

    const Y = {
        x: Z.x + ground * Math.cos(ground_angle),
        y: Z.y + ground * Math.sin(ground_angle)
    }; // ground

    // Calculate positions for the four-bar linkage
    let cfg = 0;
    if (fb_configCheckbox.checked) {
        cfg = 1;
    }
    const angles = fourbar_position(crank, coupler, output, ground,
        crank_angle, ground_angle, cfg)
    const coupler_angle = angles[0];
    const output_angle = angles[1];

    const A = {
        x: Z.x + crank * Math.cos(crank_angle),
        y: Z.y + crank * Math.sin(crank_angle)
    };

    const B = {
        x: A.x + coupler * Math.cos(coupler_angle),
        y: A.y + coupler * Math.sin(coupler_angle)
    };

    const P = {
        x: A.x + fb_APSlider.value * Math.cos(fb_BAPSlider.value * Math.PI / 180 + coupler_angle),
        y: A.y + fb_APSlider.value * Math.sin(fb_BAPSlider.value * Math.PI / 180 + coupler_angle)
    };

    A.y = fb_canvas.height - A.y;
    B.y = fb_canvas.height - B.y;
    Z.y = fb_canvas.height - Z.y;
    Y.y = fb_canvas.height - Y.y;
    P.y = fb_canvas.height - P.y;

    // Draw the links
    fb_ctx.lineWidth = 2;
    // Draw the ground.
    fb_ctx.beginPath();
    fb_ctx.moveTo(Z.x, Z.y);
    fb_ctx.strokeStyle = '#000000';
    fb_ctx.lineTo(Y.x, Y.y);
    fb_ctx.stroke();

    // Draw the crank.
    fb_ctx.beginPath();
    fb_ctx.moveTo(Z.x, Z.y);
    fb_ctx.strokeStyle = '#FF0000';
    fb_ctx.lineTo(A.x, A.y);
    fb_ctx.stroke();

    // Draw the coupler.
    fb_ctx.beginPath();
    fb_ctx.moveTo(A.x, A.y);
    fb_ctx.strokeStyle = "#00FF00";
    fb_ctx.lineTo(B.x, B.y);
    fb_ctx.stroke();

    fb_ctx.beginPath();
    fb_ctx.moveTo(A.x, A.y);
    fb_ctx.strokeStyle = "#00FF00";
    fb_ctx.lineTo(P.x, P.y);
    fb_ctx.stroke();

    fb_ctx.beginPath();
    fb_ctx.moveTo(P.x, P.y);
    fb_ctx.strokeStyle = "#00FF00";
    fb_ctx.lineTo(B.x, B.y);
    fb_ctx.stroke();

    // Draw the output.
    fb_ctx.beginPath();
    fb_ctx.moveTo(Y.x, Y.y);
    fb_ctx.strokeStyle = "#0000FF";
    fb_ctx.lineTo(B.x, B.y);
    fb_ctx.stroke();

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", fb_ctx);
    drawGround(Y, "rgb(0,0,0,0.5", fb_ctx);
    drawPinJoint(Z, fb_ctx);
    drawPinJoint(Y, fb_ctx);
    drawPinJoint(B, fb_ctx);
    drawPinJoint(A, fb_ctx);


    // show the points
    fb_ctx.font = 'bold 12pt Arial';
    fb_ctx.fillText('Z', Z.x * 0.95, Z.y * 1.05)
    fb_ctx.fillText('Y', Y.x * 1.05, Y.y * 1.05)
    fb_ctx.fillText('B', B.x * 1.05, B.y * 0.95)
    fb_ctx.fillText('A', A.x * 0.95, A.y * 1.05)
    fb_ctx.fillText('P', P.x * 0.95, P.y * 0.95)
    //fb_ctx.fillText('ZAB = '+((Math.PI-crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //fb_ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta3').innerText = (coupler_angle * 180 / Math.PI).toFixed(2);
    document.getElementById('theta4').innerText = (output_angle * 180 / Math.PI).toFixed(2);
    //fb_ctx.fillText('YZA = '+(wrapAngle(crank_angle)*180/Math.PI).toFixed(2), Z.x*0.85, Z.y*0.85);

    // fb_crankAngleSlider.value=wrapAngle(crank_angle)*180/Math.PI;
    // fb_crankAngleSlider.oninput = () => updateDisplay(fb_crankAngleSlider, 'fb_crankAngleSlider');
    // document.getElementById('fb_crankAngleSlider').innerText = fb_crankAngleSlider.value;

    let region = new Path2D();
    region.moveTo(A.x, A.y);
    region.lineTo(P.x, P.y);
    region.lineTo(B.x, B.y);
    region.closePath();

    // Fill path
    fb_ctx.fillStyle = "rgba(0, 0, 0, 0.2)";
    fb_ctx.fill(region, "evenodd");

    fb_ctx.restore();

}

function drawCrankSlider() {
    const cs_coupler = parseInt(cs_couplerSlider.value);
    const cs_crank = parseInt(cs_crankSlider.value);
    const cs_offset = parseInt(cs_offsetSlider.value);
    let cs_crank_angle = parseInt(cs_crankAngleSlider.value) * Math.PI / 180; // Starting angle for the rotation

    cs_ctx.clearRect(0, 0, cs_canvas.width, cs_canvas.height);
    //drawCouplerCurve();

    // Fixed point (Z)
    const Z = { x: 200, y: 100 };

    // Calculate positions for the four-bar linkage
    let cfg = 1;
    if (cs_configCheckbox.checked) {
        cfg = 0;
    }
    const t3d = cs_position(cs_crank, cs_coupler, cs_offset,
        cs_crank_angle, cfg)
    const cs_coupler_angle = t3d[0];
    const d_cs = t3d[1];

    const A = {
        x: Z.x + cs_crank * Math.cos(cs_crank_angle),
        y: Z.y + cs_crank * Math.sin(cs_crank_angle)
    };

    const B = {
        x: A.x + cs_coupler * Math.cos(cs_coupler_angle - Math.PI),
        y: A.y + cs_coupler * Math.sin(cs_coupler_angle - Math.PI)
    };


    A.y = cs_canvas.height - A.y;
    B.y = cs_canvas.height - B.y;
    Z.y = cs_canvas.height - Z.y;


    // Draw the links
    cs_ctx.lineWidth = 2;
    // Draw the crank.
    cs_ctx.beginPath();
    cs_ctx.moveTo(Z.x, Z.y);
    cs_ctx.strokeStyle = '#FF0000';
    cs_ctx.lineTo(A.x, A.y);
    cs_ctx.stroke();

    // Draw the coupler.
    cs_ctx.beginPath();
    cs_ctx.moveTo(A.x, A.y);
    cs_ctx.strokeStyle = "#00FF00";
    cs_ctx.lineTo(B.x, B.y);
    cs_ctx.stroke();

    // Draw the second ground
    cs_ctx.beginPath();
    cs_ctx.setLineDash([1, 2]);
    cs_ctx.moveTo(Z.x - cs_crank - cs_coupler, B.y + 10);
    cs_ctx.strokeStyle = "#000000";
    cs_ctx.lineTo(Z.x + cs_crank + cs_coupler, B.y + 10);
    cs_ctx.stroke();
    cs_ctx.setLineDash([]); // Empty array sets a solid line

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", cs_ctx);
    drawGround(B, "rgb(0,0,255,0.5", cs_ctx);
    drawPinJoint(Z, cs_ctx);
    drawPinJoint(B, cs_ctx);
    drawPinJoint(A, cs_ctx);

    // show the points
    cs_ctx.font = 'bold 12pt Arial';
    cs_ctx.fillStyle = "rgb(0,0,0,0.5";
    cs_ctx.fillText('Z', Z.x * 0.95, Z.y * 1.05)
    cs_ctx.fillText('B', B.x * 1.05, B.y * 0.95)
    cs_ctx.fillText('A', A.x * 0.95, A.y * 1.05)

    document.getElementById('theta3_cs').innerText = (cs_coupler_angle * 180 / Math.PI).toFixed(2);
    document.getElementById('d_cs').innerText = d_cs.toFixed(2);

}



function drawSliderCrank() {
    const scr_coupler = parseInt(scr_couplerSlider.value);
    const scr_crank = parseInt(scr_crankSlider.value);
    const scr_offset = parseInt(scr_offsetSlider.value);
    let scr_slider_distance = parseInt(scr_slider_distance_slider.value); // Starting angle for the rotation

    scr_ctx.clearRect(0, 0, scr_canvas.width, scr_canvas.height);
    //drawCouplerCurve();

    // Fixed point (Z)
    const Z = { x: 200, y: 100 };

    // Calculate positions for the four-bar linkage
    let cfg = 1;
    if (scr_configCheckbox.checked) {
        cfg = 0;
    }
    const angles = scr_position(scr_crank, scr_coupler, scr_offset,
        scr_slider_distance, cfg)
    const scr_crank_angle = angles[0];
    const scr_coupler_angle = angles[1];

    const A = {
        x: Z.x + scr_crank * Math.cos(scr_crank_angle),
        y: Z.y + scr_crank * Math.sin(scr_crank_angle)
    };

    const B = {
        x: A.x + scr_coupler * Math.cos(scr_coupler_angle - Math.PI),
        y: A.y + scr_coupler * Math.sin(scr_coupler_angle - Math.PI)
    };


    A.y = scr_canvas.height - A.y;
    B.y = scr_canvas.height - B.y;
    Z.y = scr_canvas.height - Z.y;


    // Draw the links
    scr_ctx.lineWidth = 2;
    // Draw the crank.
    scr_ctx.beginPath();
    scr_ctx.moveTo(Z.x, Z.y);
    scr_ctx.strokeStyle = '#FF0000';
    scr_ctx.lineTo(A.x, A.y);
    scr_ctx.stroke();

    // Draw the coupler.
    scr_ctx.beginPath();
    scr_ctx.moveTo(A.x, A.y);
    scr_ctx.strokeStyle = "#00FF00";
    scr_ctx.lineTo(B.x, B.y);
    scr_ctx.stroke();

    // Draw the second ground
    scr_ctx.beginPath();
    scr_ctx.setLineDash([1, 2]);
    scr_ctx.moveTo(Z.x - scr_crank - scr_coupler, B.y + 10);
    scr_ctx.strokeStyle = "#000000";
    scr_ctx.lineTo(Z.x + scr_crank + scr_coupler, B.y + 10);
    scr_ctx.stroke();
    scr_ctx.setLineDash([]); // Empty array sets a solid line

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", scr_ctx);
    drawGround(B, "rgb(0,0,255,0.5", scr_ctx);
    drawPinJoint(Z, scr_ctx);
    drawPinJoint(B, scr_ctx);
    drawPinJoint(A, scr_ctx);

    // show the points
    scr_ctx.font = 'bold 12pt Arial';
    scr_ctx.fillStyle = "rgb(0,0,0,0.5";
    scr_ctx.fillText('Z', Z.x * 0.95, Z.y * 1.05)
    scr_ctx.fillText('B', B.x * 1.05, B.y * 0.95)
    scr_ctx.fillText('A', A.x * 0.95, A.y * 1.05)

    document.getElementById('theta2_scr').innerText = (scr_crank_angle * 180 / Math.PI).toFixed(2);;
    document.getElementById('theta3_scr').innerText = (scr_coupler_angle * 180 / Math.PI).toFixed(2);

}


function draw_inv_crank_slider() {
    const ics_ground = parseInt(ics_groundSlider.value);
    const ics_output = parseInt(ics_outputSlider.value);
    const ics_crank = parseInt(ics_crank_slider.value);
    const ics_crank_angle = parseInt(ics_crankAngleSlider.value) * Math.PI / 180; // Starting angle for the rotation
    const ics_gamma_angle = parseInt(ics_gammaSlider.value) * Math.PI / 180; // Starting angle for the rotation

    const ics_ground_angle = 0;

    // Clear the fb_canvas
    ics_ctx.clearRect(0, 0, ics_canvas.width, ics_canvas.height);

    // Fixed point (Z)
    const Z = { x: 100, y: 100 };

    const Y = {
        x: Z.x + ics_ground * Math.cos(ics_ground_angle),
        y: Z.y + ics_ground * Math.sin(ics_ground_angle)
    }; // ground

    // Calculate positions for the four-bar linkage
    let cfg = 0;
    if (ics_configCheckBox.checked) {
        cfg = 1;
    }
    const ics_angles = ics_position(ics_crank, ics_output, ics_ground,
        ics_gamma_angle, ics_crank_angle, cfg)
    const ics_coupler_angle = ics_angles[0];
    const ics_output_angle = ics_angles[1];
    const ics_b = ics_angles[2];

    const A = {
        x: Z.x + ics_crank * Math.cos(ics_crank_angle),
        y: Z.y + ics_crank * Math.sin(ics_crank_angle)
    };

    const B = {
        x: A.x + ics_b * Math.cos(ics_coupler_angle - Math.PI),
        y: A.y + ics_b * Math.sin(ics_coupler_angle - Math.PI)
    };

    const P = {
        x: A.x + Math.sign(ics_b)*(ics_crank + ics_ground + ics_output) * Math.cos(ics_coupler_angle - Math.PI),
        y: A.y + Math.sign(ics_b)*(ics_crank + ics_ground + ics_output) * Math.sin(ics_coupler_angle - Math.PI)
    };

    const B1 = {
        x: A.x + (ics_b - 10) * Math.cos(ics_coupler_angle - Math.PI),
        y: A.y + (ics_b - 10) * Math.sin(ics_coupler_angle - Math.PI)
    };

    const B2 = {
        x: A.x + (ics_b + 10) * Math.cos(ics_coupler_angle - Math.PI),
        y: A.y + (ics_b + 10) * Math.sin(ics_coupler_angle - Math.PI)
    };


    A.y = ics_canvas.height - A.y;
    B.y = ics_canvas.height - B.y;
    Z.y = ics_canvas.height - Z.y;
    Y.y = ics_canvas.height - Y.y;
    P.y = ics_canvas.height - P.y;
    B1.y = ics_canvas.height - B1.y;
    B2.y = ics_canvas.height - B2.y;

    // Draw the links
    ics_ctx.lineWidth = 2;
    // Draw the ground.
    ics_ctx.beginPath();
    ics_ctx.moveTo(Z.x, Z.y);
    ics_ctx.strokeStyle = '#000000';
    ics_ctx.lineTo(Y.x, Y.y);
    ics_ctx.stroke();

    // Draw the crank.
    ics_ctx.beginPath();
    ics_ctx.moveTo(Z.x, Z.y);
    ics_ctx.strokeStyle = '#FF0000';
    ics_ctx.lineTo(A.x, A.y);
    ics_ctx.stroke();

    // Draw the coupler.
    ics_ctx.beginPath();
    ics_ctx.moveTo(A.x, A.y);
    ics_ctx.strokeStyle = "#00FF00";
    ics_ctx.lineTo(P.x, P.y);
    ics_ctx.stroke();

    // Draw the output.
    ics_ctx.beginPath();
    ics_ctx.moveTo(Y.x, Y.y);
    ics_ctx.strokeStyle = "#0000FF";
    ics_ctx.lineTo(B.x, B.y);
    ics_ctx.stroke();

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", ics_ctx);
    drawGround(Y, "rgb(0,0,0,0.5", ics_ctx);
    drawPinJoint(Z, ics_ctx);
    drawPinJoint(Y, ics_ctx);

    // draw the slider
    ics_ctx.save();
    ics_ctx.lineWidth = 10;
    ics_ctx.strokeStyle = 'rgba(0, 255, 255, 0.5)';
    ics_ctx.beginPath();
    ics_ctx.moveTo(B1.x, B1.y);
    ics_ctx.lineTo(B2.x, B2.y);
    ics_ctx.stroke();
    ics_ctx.restore();

    drawPinJoint(A, ics_ctx);


    // show the points
    ics_ctx.font = 'bold 12pt Arial';
    ics_ctx.fillStyle = "rgb(0,0,0,0.5";
    ics_ctx.fillText('Z', Z.x * 0.95, Z.y * 1.05)
    ics_ctx.fillText('Y', Y.x * 1.05, Y.y * 1.05)
    ics_ctx.fillText('B', B.x * 1.05, B.y * 0.95)
    ics_ctx.fillText('A', A.x * 0.95, A.y * 1.05)
    //fb_ctx.fillText('ZAB = '+((Math.PI-fb_crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //fb_ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta3_ics').innerText = (wrapAngle(ics_coupler_angle) * 180 / Math.PI).toFixed(2);
    document.getElementById('theta4_ics').innerText = (wrapAngle(ics_output_angle) * 180 / Math.PI).toFixed(2);
    document.getElementById('b_ics').innerText = ics_b.toFixed(2);

    //fb_ctx.fillText('YZA = '+(wrapAngle(fb_crank_angle)*180/Math.PI).toFixed(2), Z.x*0.85, Z.y*0.85);

    // ics_crankAngleSlider.value=wrapAngle(ics_crank_angle)*180/Math.PI;
    // ics_crankAngleSlider.oninput = () => updateDisplay(ics_crankAngleSlider, 'fb_crank_angle_slider');
    // document.getElementById('ics_crankAngleSlider').innerText = ics_crankAngleSlider.value;

}

function draw_inv_slider_crank() {
    const iscr_ground = parseInt(iscr_groundSlider.value);
    const iscr_output = parseInt(iscr_outputSlider.value);
    const iscr_crank = parseInt(iscr_crank_slider.value);
    const iscr_b = parseInt(iscr_coupler_length_slider.value); // Starting angle for the rotation
    const iscr_gamma_angle = parseInt(iscr_gammaSlider.value) * Math.PI / 180; // Starting angle for the rotation

    const iscr_ground_angle = 0;

    // Clear the fb_canvas
    iscr_ctx.clearRect(0, 0, iscr_canvas.width, iscr_canvas.height);

    // Fixed point (Z)
    const Z = { x: 100, y: 100 };

    const Y = {
        x: Z.x + iscr_ground * Math.cos(iscr_ground_angle),
        y: Z.y + iscr_ground * Math.sin(iscr_ground_angle)
    }; // ground

    // Calculate positions for the four-bar linkage
    let cfg = 0;
    if (iscr_configCheckBox.checked) {
        cfg = 1;
    }
    const iscr_angles = iscr_position(iscr_crank, iscr_b, iscr_output, iscr_ground,
        iscr_gamma_angle, cfg)
    const iscr_crank_angle = iscr_angles[0];
    const iscr_coupler_angle = iscr_angles[1];
    const iscr_output_angle = iscr_angles[2];
    
    const A = {
        x: Z.x + iscr_crank * Math.cos(iscr_crank_angle),
        y: Z.y + iscr_crank * Math.sin(iscr_crank_angle)
    };

    const B = {
        x: A.x + iscr_b * Math.cos(iscr_coupler_angle - Math.PI),
        y: A.y + iscr_b * Math.sin(iscr_coupler_angle - Math.PI)
    };

    const P = {
        x: A.x + (iscr_crank + iscr_ground + iscr_output) * Math.cos(iscr_coupler_angle - Math.PI),
        y: A.y + (iscr_crank + iscr_ground + iscr_output) * Math.sin(iscr_coupler_angle - Math.PI)
    };

    const B1 = {
        x: A.x + (iscr_b - 10) * Math.cos(iscr_coupler_angle - Math.PI),
        y: A.y + (iscr_b - 10) * Math.sin(iscr_coupler_angle - Math.PI)
    };

    const B2 = {
        x: A.x + (iscr_b + 10) * Math.cos(iscr_coupler_angle - Math.PI),
        y: A.y + (iscr_b + 10) * Math.sin(iscr_coupler_angle - Math.PI)
    };


    A.y = iscr_canvas.height - A.y;
    B.y = iscr_canvas.height - B.y;
    Z.y = iscr_canvas.height - Z.y;
    Y.y = iscr_canvas.height - Y.y;
    P.y = iscr_canvas.height - P.y;
    B1.y = iscr_canvas.height - B1.y;
    B2.y = iscr_canvas.height - B2.y;

    // Draw the links
    iscr_ctx.lineWidth = 2;
    // Draw the ground.
    iscr_ctx.beginPath();
    iscr_ctx.moveTo(Z.x, Z.y);
    iscr_ctx.strokeStyle = '#000000';
    iscr_ctx.lineTo(Y.x, Y.y);
    iscr_ctx.stroke();

    // Draw the crank.
    iscr_ctx.beginPath();
    iscr_ctx.moveTo(Z.x, Z.y);
    iscr_ctx.strokeStyle = '#FF0000';
    iscr_ctx.lineTo(A.x, A.y);
    iscr_ctx.stroke();

    // Draw the coupler.
    iscr_ctx.beginPath();
    iscr_ctx.moveTo(A.x, A.y);
    iscr_ctx.strokeStyle = "#00FF00";
    iscr_ctx.lineTo(P.x, P.y);
    iscr_ctx.stroke();

    // Draw the output.
    iscr_ctx.beginPath();
    iscr_ctx.moveTo(Y.x, Y.y);
    iscr_ctx.strokeStyle = "#0000FF";
    iscr_ctx.lineTo(B.x, B.y);
    iscr_ctx.stroke();

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", iscr_ctx);
    drawGround(Y, "rgb(0,0,0,0.5", iscr_ctx);
    drawPinJoint(Z, iscr_ctx);
    drawPinJoint(Y, iscr_ctx);

    // draw the slider
    iscr_ctx.save();
    iscr_ctx.lineWidth = 10;
    iscr_ctx.strokeStyle = 'rgba(0, 255, 255, 0.5)';
    iscr_ctx.beginPath();
    iscr_ctx.moveTo(B1.x, B1.y);
    iscr_ctx.lineTo(B2.x, B2.y);
    iscr_ctx.stroke();
    iscr_ctx.restore();

    drawPinJoint(A, iscr_ctx);


    // show the points
    iscr_ctx.font = 'bold 12pt Arial';
    iscr_ctx.fillStyle = "rgb(0,0,0,0.5";
    iscr_ctx.fillText('Z', Z.x * 0.95, Z.y * 1.05)
    iscr_ctx.fillText('Y', Y.x * 1.05, Y.y * 1.05)
    iscr_ctx.fillText('B', B.x * 1.05, B.y * 0.95)
    iscr_ctx.fillText('A', A.x * 0.95, A.y * 1.05)
    //fb_ctx.fillText('ZAB = '+((Math.PI-fb_crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //fb_ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta2_iscr').innerText = (wrapAngle(iscr_crank_angle) * 180 / Math.PI).toFixed(2);
    document.getElementById('theta3_iscr').innerText = (wrapAngle(iscr_coupler_angle) * 180 / Math.PI).toFixed(2);
    document.getElementById('theta4_iscr').innerText = (wrapAngle(iscr_output_angle) * 180 / Math.PI).toFixed(2);

    //fb_ctx.fillText('YZA = '+(wrapAngle(fb_crank_angle)*180/Math.PI).toFixed(2), Z.x*0.85, Z.y*0.85);

    // ics_crankAngleSlider.value=wrapAngle(ics_crank_angle)*180/Math.PI;
    // ics_crankAngleSlider.oninput = () => updateDisplay(ics_crankAngleSlider, 'fb_crank_angle_slider');
    // document.getElementById('ics_crankAngleSlider').innerText = ics_crankAngleSlider.value;

}


function wrapAngle(angle) {
    return angle - 2 * Math.PI * Math.floor(angle / (2 * Math.PI));
}
function drawPoint(point, color, ctx) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(point.x, point.y, 5, 0, Math.PI * 2);
    ctx.fill();
}

function drawPinJoint(point, ctx) {
    //ctx.fillStyle = "rgba(0,0,0,1)";
    ctx.beginPath();
    ctx.strokeStyle = 'black';
    ctx.arc(point.x, point.y, 3, 0, Math.PI * 2);
    ctx.stroke();
    //ctx.fill();
}

function drawGround(point, color, ctx) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.rect(point.x - 10, point.y - 10, 20, 20);
    // ctx.stroke();
    ctx.fill()
}

function animate() {
    if (isPlaying) {
        crank_angle += 0.05; // Change the angle for rotation
        drawFourBar();
        requestAnimationFrame(animate); // Call animate again for the next frame
    }
}

// Initial draw
// drawFourBar();
// drawCrankSlider();

