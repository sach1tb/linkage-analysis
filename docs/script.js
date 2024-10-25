const fb_canvas = document.getElementById('fb_canvas');
//const theta3 = document.getElementById('theta3');
const ctx = fb_canvas.getContext('2d');

const cs_canvas = document.getElementById('cs_canvas');
const cs_ctx = cs_canvas.getContext('2d');

// inverted crank slider
const ics_canvas = document.getElementById('ics_canvas');
const ics_ctx = ics_canvas.getContext('2d');

// Flip the y-axis
//ctx.scale(1, -1);
//ctx.transform(1, 0, 0, -1, 0, fb_canvas.height)

let scale = 1;
let originX = 0;
let originY = 0;

// Get slider elements
// fourbar
const groundSlider = document.getElementById('ground');
const couplerSlider = document.getElementById('coupler');
const APSlider = document.getElementById('APlen');
const BAPSlider = document.getElementById('BAPAngle');
const outputSlider = document.getElementById('output');
const crankSlider = document.getElementById('crank');
const crankAngleSlider = document.getElementById('crankA');
const groundAngleSlider = document.getElementById('groundA');
const configCheckbox = document.getElementById('config');
//const playButton = document.getElementById('playButton');

// crank slider
const cs_couplerSlider = document.getElementById('cs_coupler');
const cs_crankSlider = document.getElementById('cs_crank');
const cs_offsetSlider = document.getElementById('cs_offset');
const cs_crankAngleSlider = document.getElementById('cs_crankA');
const cs_configCheckbox = document.getElementById('cs_config');

// inverted crank slider
const ics_crank_slider = document.getElementById('ics_crank_slider');
const ics_gammaSlider = document.getElementById('ics_gammaSlider');
const ics_groundSlider = document.getElementById('ics_groundSlider');
const ics_outputSlider = document.getElementById('ics_outputSlider');
const ics_crankAngleSlider = document.getElementById('ics_crankAngleSlider');
const ics_configCheckBox = document.getElementById('ics_configCheckBox');
document.getElementById("ics_configCheckBox").disabled = true


// fourbar
//let isPlaying = false;
//let ground_angle = groundAngleSlider.value*Math.PI/180; // Starting angle for the rotation
//let crank_angle = crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation

// crank slider
//let cs_crank_angle = cs_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation


// Display initial values
// fourbar
document.getElementById('groundLength').innerText = groundSlider.value;
document.getElementById('couplerLength').innerText = couplerSlider.value;
document.getElementById('APLength').innerText = APSlider.value;
document.getElementById('BAP').innerText = BAPSlider.value;
document.getElementById('outputLength').innerText = outputSlider.value;
document.getElementById('crankLength').innerText = crankSlider.value;
document.getElementById('crankA').innerText = crankAngleSlider.value;
document.getElementById('groundA').innerText = groundAngleSlider.value;

// crank slider
document.getElementById('cs_couplerLength').innerText = cs_couplerSlider.value;
document.getElementById('cs_crankLength').innerText = cs_crankSlider.value;
document.getElementById('cs_offsetHeight').innerText = cs_offsetSlider.value;
document.getElementById('cs_crankAngleSlider').innerText = cs_crankAngleSlider.value;

// inverted crank slider
document.getElementById('ics_groundLength').innerText = ics_groundSlider.value;
document.getElementById('ics_crank_length').innerText = ics_crank_slider.value;
document.getElementById('ics_outputLength').innerText = ics_outputSlider.value;
document.getElementById('ics_crankAngleSlider').innerText = ics_crankAngleSlider.value;
document.getElementById('ics_gammaSlider').innerText = ics_gammaSlider.value;

// Event listeners to update the display and redraw
// fourbar
groundSlider.oninput = () => updateDisplay(groundSlider, 'groundLength');
couplerSlider.oninput = () => updateDisplay(couplerSlider, 'couplerLength');
APSlider.oninput = () => updateDisplay(APSlider, 'APLength');
BAPSlider.oninput = () => updateDisplay(BAPSlider, 'BAP');
outputSlider.oninput = () => updateDisplay(outputSlider, 'outputLength');
crankSlider.oninput = () => updateDisplay(crankSlider, 'crankLength');
crankAngleSlider.oninput = () => updateDisplay(crankAngleSlider, 'crankAngleSlider');
groundAngleSlider.oninput = () => updateDisplay(groundAngleSlider, 'groundAngleSlider');

// crank slider
cs_crankSlider.oninput = () => updateDisplay(cs_crankSlider, 'cs_crankLength');
cs_offsetSlider.oninput = () => updateDisplay(cs_offsetSlider, 'cs_offsetHeight');
cs_crankAngleSlider.oninput = () => updateDisplay(cs_crankAngleSlider, 'cs_crankAngleSlider');
cs_couplerSlider.oninput = () => updateDisplay(cs_couplerSlider, 'cs_couplerLength');

// inverted crank slider
ics_groundSlider.oninput = () => updateDisplay(ics_groundSlider, 'ics_groundLength');
ics_crank_slider.oninput = () => updateDisplay(ics_crank_slider, 'ics_crank_length');
ics_outputSlider.oninput = () => updateDisplay(ics_outputSlider, 'ics_outputLength');
ics_crankAngleSlider.oninput = () => updateDisplay(ics_crankAngleSlider, 'ics_crankAngle');
ics_gammaSlider.oninput = () => updateDisplay(ics_gammaSlider, 'ics_gammaAngle');

// zoom
fb_canvas.addEventListener("wheel", function(e) {
    e.preventDefault();
    const delta = e.deltaY < 0 ? 1.01 : 0.99;
    const rect = fb_canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
  
    // Zoom towards the mouse cursor
    originX = x - (x - originX) * delta;
    originY = y - (y - originY) * delta;
    scale *= delta;
  
    drawFourBar();
  });


// configuration change
// fourbar
config.addEventListener("change", function() {
    drawFourBar();
  });

// crank slider
cs_config.addEventListener("change", function() {
    drawCrankSlider();
  });


  // inverted crank slider
ics_configCheckBox.addEventListener("change", function() {
    draw_inv_crank_slider();
  });
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
draw_inv_crank_slider();

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
    draw_inv_crank_slider();
}

function fourbar_position(a,b,c,d,t2,t1,cfg) {
    const K1=2*d*c*Math.cos(t1)-2*a*c*Math.cos(t2);
    const K2=2*d*c*Math.sin(t1)-2*a*c*Math.sin(t2);
    const K3=2*a*d*Math.sin(t1)*Math.sin(t2) + 2*a*d*Math.cos(t1)*Math.cos(t2);
    const K4=b**2-a**2-c**2-d**2;
    
    const A=K4+K1+K3;
    const B=-2*K2;
    const C=K4-K1+K3;

    const t4c=2*Math.atan((-B-Math.sqrt(B**2-4*A*C))/(2*A));
    const t4o=2*Math.atan((-B+Math.sqrt(B**2-4*A*C))/(2*A));

    const K5=2*a*b*Math.cos(t2)-2*b*d*Math.cos(t1);
    const K6=2*a*b*Math.sin(t2)-2*b*d*Math.sin(t1);
    const K7=2*a*d*Math.sin(t1)*Math.sin(t2) + 2*a*d*Math.cos(t1)*Math.cos(t2);
    const K8=(c**2-d**2-a**2-b**2);


    const D=K8+K7+K5;
    const E=-2*K6;
    const F=K8-K5+K7;

   
    const t3c=2*Math.atan((-E+Math.sqrt(E**2-4*D*F))/(2*D));
    const t3o=2*Math.atan((-E-Math.sqrt(E**2-4*D*F))/(2*D));

    if (cfg==1) {
        t3=t3o;
        t4=t4o;
    } else {
        t3=t3c;
        t4=t4c;
    }
    return [t3, t4]
}

function cs_position(a,b,c,t2,cfg){
    t31=Math.asin((a*Math.sin(t2)-c)/b);
    t32=Math.PI-t31;
    if (cfg==1) {
        t3=t31;
    } else {
        t3=t32;
    }
    d=a*Math.cos(t2)-b*Math.cos(t3);
    return [t3, d]
}

function ics_position(a,c,d,gamma,t2,cfg){
    P=a*Math.sin(t2)*Math.sin(gamma) + (a*Math.cos(t2)-d)*Math.cos(gamma);
    Q=-a*Math.sin(t2)*Math.cos(gamma) + (a*Math.cos(t2)-d)*Math.sin(gamma);
    R=-c*Math.sin(gamma);
    
    S=R-Q;
    T=2*P;
    U=Q+R;
    
    t41=2*Math.atan2((-T+Math.sqrt(T**2-4*S*U)),(2*S));
    t42=2*Math.atan2((-T-Math.sqrt(T**2-4*S*U)),(2*S));
    
    t31=t41+gamma;
    t32=t42+gamma;
    
    b1=(a*Math.sin(t2)-c*Math.sin(t41))/(Math.sin(t31));
    b2=(a*Math.sin(t2)-c*Math.sin(t42))/(Math.sin(t32));
    //b2=Math.abs(b2);

    if (cfg==1) {
        t3=t31;
        t4=t41;
        b=b1;
    } else {
        t3=t32;
        t4=t42;
        b=b2;
    }
    //d=a*Math.cos(t2)-b*Math.cos(t3);
    return [t3, t4, b]

}

function drawCouplerCurve(){
    const ground = parseInt(groundSlider.value);
    const coupler = parseInt(couplerSlider.value);
    const output = parseInt(outputSlider.value);
    const crank = parseInt(crankSlider.value);

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };
    let cfg=0;
    if (configCheckbox.checked) {
        cfg=1;
    }
    for (var t2 = 0; t2 < 500; t2++)
        {
            const angles=fourbar_position(crank,coupler,output,ground,
                t2*2*Math.PI/500,ground_angle,cfg)
            const P = {
                    x: Z.x + crank * Math.cos(t2) + APSlider.value * Math.cos(BAPSlider.value*Math.PI/180+angles[0]),
                    y: Z.y + crank * Math.sin(t2) + APSlider.value * Math.sin(BAPSlider.value*Math.PI/180+angles[0])
            };
            P.y=fb_canvas.height-P.y;
            ctx.fillRect(P.x,P.y,1,1);
        }
}

function drawFourBar() {
    const ground = parseInt(groundSlider.value);
    const coupler = parseInt(couplerSlider.value);
    const output = parseInt(outputSlider.value);
    const crank = parseInt(crankSlider.value);
    const crank_angle = crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation
    const ground_angle = groundAngleSlider.value*Math.PI/180; // Starting angle for the rotation

    //if (animate){
    //    const crank_angle = parseInt(crankAngleSlider.value)*Math.PI/180;
    //}
    // Clear the fb_canvas
    ctx.clearRect(0, 0, fb_canvas.width, fb_canvas.height);
    //drawCouplerCurve();
    ctx.save();
    ctx.translate(originX, originY);
    ctx.scale(scale, scale);

    // Draw your content here
    // Fixed point (Z)
    const Z= { x: 100, y: 100 };

    const Y = { x: Z.x + ground * Math.cos(ground_angle), 
        y: Z.y+ ground * Math.sin(ground_angle) }; // ground

    // Calculate positions for the four-bar linkage
    let cfg=0;
    if (configCheckbox.checked) {
        cfg=1;
    }
    const angles=fourbar_position(crank,coupler,output,ground,
        crank_angle,ground_angle,cfg)
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
        x: A.x + APSlider.value * Math.cos(BAPSlider.value*Math.PI/180+coupler_angle),
        y: A.y + APSlider.value * Math.sin(BAPSlider.value*Math.PI/180+coupler_angle)
    };

    A.y=fb_canvas.height-A.y;
    B.y=fb_canvas.height-B.y;
    Z.y=fb_canvas.height-Z.y;
    Y.y=fb_canvas.height-Y.y;
    P.y=fb_canvas.height-P.y;

    // Draw the links
    // Draw the ground.
    ctx.beginPath();
    ctx.moveTo(Z.x, Z.y);
    ctx.strokeStyle = '#000000';
    ctx.lineTo(Y.x, Y.y);
    ctx.stroke();

    // Draw the crank.
    ctx.beginPath();
    ctx.moveTo(Z.x, Z.y);
    ctx.strokeStyle = '#FF0000';
    ctx.lineTo(A.x, A.y);
    ctx.stroke();

    // Draw the coupler.
    ctx.beginPath();
    ctx.moveTo(A.x, A.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(A.x, A.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(P.x, P.y);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(P.x, P.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();
    
    // Draw the output.
    ctx.beginPath();
    ctx.moveTo(Y.x, Y.y);
    ctx.strokeStyle = "#0000FF";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", ctx);
    drawGround(Y, "rgb(0,0,0,0.5", ctx);
    drawPinJoint(Z,ctx);
    drawPinJoint(Y,ctx);
    drawPinJoint(B, ctx);
    drawPinJoint(A, ctx);


    // show the points
    ctx.fillText('Z', Z.x*0.95, Z.y*1.05)
    ctx.fillText('Y', Y.x*1.05, Y.y*1.05)
    ctx.fillText('B', B.x*1.05, B.y*0.95)
    ctx.fillText('A', A.x*0.95, A.y*1.05)
    ctx.fillText('P', P.x*0.95, P.y*0.95)
    //ctx.fillText('ZAB = '+((Math.PI-crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta3').innerText = (coupler_angle*180/Math.PI).toFixed(2);
    document.getElementById('theta4').innerText = (output_angle*180/Math.PI).toFixed(2);
    //ctx.fillText('YZA = '+(wrapAngle(crank_angle)*180/Math.PI).toFixed(2), Z.x*0.85, Z.y*0.85);

    // crankAngleSlider.value=wrapAngle(crank_angle)*180/Math.PI;
    // crankAngleSlider.oninput = () => updateDisplay(crankAngleSlider, 'crankAngleSlider');
    // document.getElementById('crankAngleSlider').innerText = crankAngleSlider.value;

    let region = new Path2D();
    region.moveTo(A.x, A.y);
    region.lineTo(P.x, P.y);
    region.lineTo(B.x, B.y);
    region.closePath();

    // Fill path
    ctx.fillStyle = "rgba(0, 0, 0, 0.2)";
    ctx.fill(region, "evenodd");

    ctx.restore();

}

function drawCrankSlider(){
    const cs_coupler = parseInt(cs_couplerSlider.value);
    const cs_crank = parseInt(cs_crankSlider.value);
    const cs_offset = parseInt(cs_offsetSlider.value);
    let cs_crank_angle = cs_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation

    cs_ctx.clearRect(0, 0, cs_canvas.width, cs_canvas.height);
    //drawCouplerCurve();

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };

    // Calculate positions for the four-bar linkage
    let cfg=1;
    if (cs_configCheckbox.checked) {
        cfg=0;
    }
    const t3d=cs_position(cs_crank,cs_coupler,cs_offset,
        cs_crank_angle,cfg)
    const cs_coupler_angle = t3d[0];
    const d_cs = t3d[1];

    const A = {
        x: Z.x + cs_crank * Math.cos(cs_crank_angle),
        y: Z.y + cs_crank * Math.sin(cs_crank_angle)
    };

    const B = {
        x: A.x + cs_coupler * Math.cos(cs_coupler_angle-Math.PI),
        y: A.y + cs_coupler * Math.sin(cs_coupler_angle-Math.PI)
    };


    A.y=cs_canvas.height-A.y;
    B.y=cs_canvas.height-B.y;
    Z.y=cs_canvas.height-Z.y;


    // Draw the links
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
    cs_ctx.moveTo(Z.x-cs_crank-cs_coupler, B.y+10);
    cs_ctx.strokeStyle = "#000000";
    cs_ctx.lineTo(Z.x+cs_crank+cs_coupler, B.y+10);
    cs_ctx.stroke();
    cs_ctx.setLineDash([]); // Empty array sets a solid line

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", cs_ctx);
    drawGround(B, "rgb(0,0,255,0.5", cs_ctx);
    drawPinJoint(Z,cs_ctx);
    drawPinJoint(B, cs_ctx);
    drawPinJoint(A,cs_ctx);

        // show the points
    cs_ctx.fillText('Z', Z.x*0.95, Z.y*1.05)
    cs_ctx.fillText('B', B.x*1.05, B.y*0.95)
    cs_ctx.fillText('A', A.x*0.95, A.y*1.05)

    document.getElementById('theta3_cs').innerText = (cs_coupler_angle*180/Math.PI).toFixed(2);
    document.getElementById('d_cs').innerText = d_cs.toFixed(2);

}


function draw_inv_crank_slider() {
    const ics_ground = parseInt(ics_groundSlider.value);
    const ics_output = parseInt(ics_outputSlider.value);
    const ics_crank = parseInt(ics_crank_slider.value);
    const ics_crank_angle = ics_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation
    const ics_gamma_angle = ics_gammaSlider.value*Math.PI/180; // Starting angle for the rotation

    const ics_ground_angle=0;

    // Clear the fb_canvas
    ics_ctx.clearRect(0, 0, ics_canvas.width, ics_canvas.height);

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };

    const Y = { x: Z.x + ics_ground * Math.cos(ics_ground_angle), 
        y: Z.y+ ics_ground * Math.sin(ics_ground_angle) }; // ground

    // Calculate positions for the four-bar linkage
    let cfg=0;
    if (ics_configCheckBox.checked) {
        cfg=1;
    }
    const ics_angles=ics_position(ics_crank,ics_output,ics_ground,
        ics_gamma_angle, ics_crank_angle,cfg)
    const ics_coupler_angle = ics_angles[0];
    const ics_output_angle = ics_angles[1];
    const ics_b = ics_angles[2];

    const A = {
        x: Z.x + ics_crank * Math.cos(ics_crank_angle),
        y: Z.y + ics_crank * Math.sin(ics_crank_angle)
    };

    const B = {
        x: A.x + ics_b * Math.cos(ics_coupler_angle-Math.PI),
        y: A.y + ics_b * Math.sin(ics_coupler_angle-Math.PI)
    };

    const P = {
        x: A.x + (ics_crank+ics_ground+ics_output) * Math.cos(ics_coupler_angle-Math.PI),
        y: A.y + (ics_crank+ics_ground+ics_output) * Math.sin(ics_coupler_angle-Math.PI)
    };

    const B1= {
        x: A.x + (ics_b-10) * Math.cos(ics_coupler_angle-Math.PI) ,
        y: A.y + (ics_b-10) * Math.sin(ics_coupler_angle-Math.PI)
    };

    const B2= {
        x: A.x + (ics_b+10) * Math.cos(ics_coupler_angle-Math.PI) ,
        y: A.y + (ics_b+10) * Math.sin(ics_coupler_angle-Math.PI)
    };
    

    A.y=ics_canvas.height-A.y;
    B.y=ics_canvas.height-B.y;
    Z.y=ics_canvas.height-Z.y;
    Y.y=ics_canvas.height-Y.y;
    P.y=ics_canvas.height-P.y;
    B1.y=ics_canvas.height-B1.y;
    B2.y=ics_canvas.height-B2.y;

    // Draw the links
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
    drawPinJoint(Z,ics_ctx);
    drawPinJoint(Y,ics_ctx);

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
    ics_ctx.fillText('Z', Z.x*0.95, Z.y*1.05)
    ics_ctx.fillText('Y', Y.x*1.05, Y.y*1.05)
    ics_ctx.fillText('B', B.x*1.05, B.y*0.95)
    ics_ctx.fillText('A', A.x*0.95, A.y*1.05)
    //fb_ctx.fillText('ZAB = '+((Math.PI-fb_crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //fb_ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta3_ics').innerText = (wrapAngle(ics_coupler_angle)*180/Math.PI).toFixed(2);
    document.getElementById('theta4_ics').innerText = (wrapAngle(ics_output_angle)*180/Math.PI).toFixed(2);
    document.getElementById('b_ics').innerText = ics_b.toFixed(2);

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

function drawGround(point, color, ctx){
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.rect(point.x-10, point.y-10, 20, 20);
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

