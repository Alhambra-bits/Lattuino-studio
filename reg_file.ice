{
  "version": "1.1",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "icezum",
    "graph": {
      "blocks": [
        {
          "id": "edcb9e77-3866-4a75-9552-f99675a0e932",
          "type": "basic.code",
          "data": {
            "code": "//----------------------------------------------------------\n//--  Registers File\n//--\n//--  Dual-port memory: (Read-first)\n//--  * Port A    \n//--    - 8 bits R/W\n//--    - 16 bits R/W\n//--  * Port B\n//--    - 8 bits R/W\n//----------------------------------------------------------\n\nreg [7:0] ram_0 [0:15];  //-- Even\nreg [7:0] ram_1 [0:15];  //-- Odd\n\nwire [3:0] adr16;\nreg  [3:0] adr16_r = 4'h0;\nreg adr_lsb_r = 1'b0;\n\nwire we0, we1;\nwire [7:0] r0i;\nwire [7:0] r1i;\n\n//-- PortB signals\nwire [3:0] adr16B;\nreg [3:0] adr16B_r;\nreg adr_lsbB_r;\n\n\n//-- Address for 16x16 registers\nassign adr16 = rd_adr_i[4:1];\nassign adr16B = rr_adr_i[4:1];\n\n//-- Decode which RAM/s will have WE asserted\nassign we0 = rd16_we_i==1 || (rd_we_i==1 && rd_adr_i[0]==0) ? 1 : 0;\nassign we1 = rd16_we_i==1 || (rd_we_i==1 && rd_adr_i[0]==1) ? 1 : 0;\n\n//-- Muxes for 16/8 bits writes \nassign r0i = rd16_we_i==1 ? rd16_i[7:0]  : rd_i;\nassign r1i = rd16_we_i==1 ? rd16_i[15:0] : rd_i;\n\n\n//-- Register the addresses\nalways @(posedge clk_i) begin\n  adr16_r <= adr16;\n  adr_lsb_r <= rd_adr_i[0];\n  adr16B_r <= adr16B;\n  adr_lsbB_r <= rr_adr_i[0];\nend\n\n//-- Writing\nalways @(posedge clk_i) begin\n  if (we0) \n    ram_0[adr16] <= r0i;\n \n  if (we1) \n    ram_1[adr16] <= r1i;\n \nend\n\n//-- Reading\nassign rd_o = adr_lsb_r  ? ram_1[adr16_r] : ram_0[adr16_r];\nassign rd16_o = {ram_1[adr16_r], ram_0[adr16_r]};\nassign rr_o = adr_lsbB_r ? ram_1[adr16B_r] : ram_0[adr16B_r];\n\n//-- Initial register file contents\n//-- Change them for debugging\n  initial begin\n    ram_1[0] = 8'hC0; ram_0[0] = 8'h80;\n    ram_1[1] = 8'hC1; ram_0[1] = 8'h81;\n    ram_1[2] = 8'hC2; ram_0[2] = 8'h82;\n    ram_1[3] = 8'hC3; ram_0[3] = 8'h83;\n    \n    ram_1[4] = 8'hC4; ram_0[4] = 8'h84;\n    ram_1[5] = 8'hC5; ram_0[5] = 8'h85;\n    ram_1[6] = 8'hC6; ram_0[6] = 8'h86;\n    ram_1[7] = 8'hC7; ram_0[7] = 8'h87;\n    \n    ram_1[8] = 8'hC8; ram_0[8] = 8'h88;\n    ram_1[9] = 8'hC9; ram_0[9] = 8'h89;\n    ram_1[10] = 8'hCA; ram_0[10] = 8'h8A;\n    ram_1[11] = 8'hCB; ram_0[11] = 8'h8B;\n    \n    ram_1[12] = 8'hCC; ram_0[12] = 8'h8C;\n    ram_1[13] = 8'hCD; ram_0[13] = 8'h8D;\n    ram_1[14] = 8'hCE; ram_0[14] = 8'h8E;\n    ram_1[15] = 8'hCF; ram_0[15] = 8'h8F;\n   end\n",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk_i"
                },
                {
                  "name": "rd_we_i"
                },
                {
                  "name": "rd_adr_i",
                  "range": "[4:0]",
                  "size": 5
                },
                {
                  "name": "rd_i",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "rd16_we_i"
                },
                {
                  "name": "rd16_i",
                  "range": "[15:0]",
                  "size": 16
                },
                {
                  "name": "rr_adr_i",
                  "range": "[4:0]",
                  "size": 5
                }
              ],
              "out": [
                {
                  "name": "rd_o",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "rd16_o",
                  "range": "[15:0]",
                  "size": 16
                },
                {
                  "name": "rr_o",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            }
          },
          "position": {
            "x": -440,
            "y": -256
          },
          "size": {
            "width": 688,
            "height": 944
          }
        },
        {
          "id": "1f74cf56-0106-4ef3-88bd-88ebf424b518",
          "type": "basic.output",
          "data": {
            "name": "LED",
            "range": "[7:0]",
            "pins": [
              {
                "index": "7",
                "name": "LED7",
                "value": "104"
              },
              {
                "index": "6",
                "name": "LED6",
                "value": "102"
              },
              {
                "index": "5",
                "name": "LED5",
                "value": "101"
              },
              {
                "index": "4",
                "name": "LED4",
                "value": "99"
              },
              {
                "index": "3",
                "name": "LED3",
                "value": "98"
              },
              {
                "index": "2",
                "name": "LED2",
                "value": "97"
              },
              {
                "index": "1",
                "name": "LED1",
                "value": "96"
              },
              {
                "index": "0",
                "name": "LED0",
                "value": "95"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 512,
            "y": -240
          }
        },
        {
          "id": "10679848-0b57-471a-8975-0df0ca5f18ec",
          "type": "basic.input",
          "data": {
            "name": "clk",
            "pins": [
              {
                "index": "0",
                "name": "CLK",
                "value": "21"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -688,
            "y": -224
          }
        },
        {
          "id": "421e8d8e-9c59-4231-a6c8-27a2c6708207",
          "type": "7c0ae704fe4f7176c6e19f8639bc59e42c836297",
          "position": {
            "x": -992,
            "y": 48
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "56436cdd-eaca-4df0-9eef-bdd040b62c52",
          "type": "b5f09a0668df8da316c9299ce5116364a98e20da",
          "position": {
            "x": -776,
            "y": 48
          },
          "size": {
            "width": 96,
            "height": 64
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "edcb9e77-3866-4a75-9552-f99675a0e932",
            "port": "rd_o"
          },
          "target": {
            "block": "1f74cf56-0106-4ef3-88bd-88ebf424b518",
            "port": "in"
          },
          "size": 8
        },
        {
          "source": {
            "block": "10679848-0b57-471a-8975-0df0ca5f18ec",
            "port": "out"
          },
          "target": {
            "block": "edcb9e77-3866-4a75-9552-f99675a0e932",
            "port": "clk_i"
          }
        },
        {
          "source": {
            "block": "56436cdd-eaca-4df0-9eef-bdd040b62c52",
            "port": "2ce52369-b09a-43f5-8a5a-fbb9ce52918a"
          },
          "target": {
            "block": "edcb9e77-3866-4a75-9552-f99675a0e932",
            "port": "rd_adr_i"
          },
          "size": 5
        },
        {
          "source": {
            "block": "421e8d8e-9c59-4231-a6c8-27a2c6708207",
            "port": "7e07d449-6475-4839-b43e-8aead8be2aac"
          },
          "target": {
            "block": "56436cdd-eaca-4df0-9eef-bdd040b62c52",
            "port": "6ae99fac-1a4b-4497-8332-951c1506f887"
          }
        }
      ]
    },
    "state": {
      "pan": {
        "x": 832.0178,
        "y": 283.98
      },
      "zoom": 0.6644
    }
  },
  "dependencies": {
    "7c0ae704fe4f7176c6e19f8639bc59e42c836297": {
      "package": {
        "name": "Bomba_x1",
        "version": "0.1",
        "description": "Bombeo de bits. Una pulsación por segundo",
        "author": "Juan Gonzalez (Obijuan)",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22113.28%22%20height=%2281.27%22%20viewBox=%220%200%20106.20044%2076.190928%22%3E%3Ctext%20y=%22443.842%22%20x=%22-155.758%22%20style=%22line-height:125%25%22%20font-weight=%22400%22%20font-size=%2240.397%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22red%22%20transform=%22translate(238.359%20-394.146)%22%3E%3Ctspan%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20y=%22443.842%22%20x=%22-155.758%22%20font-weight=%22700%22%20font-size=%2223.084%22%3E1%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M40.85%2073.768c-1.314-2.254-3.351-4.461-7.211-7.812-2.091-1.815-3.363-2.823-10.605-8.401-5.676-4.373-8.508-6.799-11.79-10.101-3.28-3.302-5.208-5.932-6.862-9.361-1.056-2.19-1.782-4.3-2.234-6.492-.573-2.785-.651-3.728-.648-7.829.004-5.381.182-6.276%201.954-9.866%201.317-2.666%202.317-4.07%204.4-6.179C9.877%205.68%2011.19%204.75%2014.03%203.35c3.155-1.556%205.437-1.964%2010.138-1.813%203.653.118%204.99.48%207.886%202.142%204.558%202.615%208.095%206.813%209.074%2010.77.16.647.325%201.177.367%201.177.042%200%20.411-.757.82-1.682%201.392-3.145%202.685-5.064%204.739-7.038C53.343.86%2063.258-.233%2071.275%204.234c3.274%201.824%205.938%204.48%208.002%207.978%201.625%202.753%202.456%206.41%202.598%2011.433.205%207.277-1.13%2012.32-4.683%2017.694-1.41%202.133-2.453%203.425-4.409%205.461-3.156%203.287-6.002%205.703-12.721%2010.798-4.24%203.215-6.753%205.282-10.39%208.55-2.915%202.618-7.431%207.176-7.866%207.938-.19.333-.362.605-.382.605-.02%200-.278-.415-.574-.923z%22%20fill=%22red%22%20stroke=%22#000%22%20stroke-width=%223%22/%3E%3Cpath%20d=%22M77.277%2053.462h25.759%22%20fill=%22none%22%20stroke=%22red%22%20stroke-width=%223%22/%3E%3Ctext%20y=%22463.171%22%20x=%22-164.04%22%20style=%22line-height:125%25%22%20font-weight=%22400%22%20font-size=%2227.48%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22red%22%20transform=%22translate(238.359%20-394.146)%22%3E%3Ctspan%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20y=%22463.171%22%20x=%22-164.04%22%20font-weight=%22700%22%20font-size=%2215.703%22%3ESeg%3C/tspan%3E%3C/text%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "8709aff2-3586-4a6f-b6c5-d8751d3bc45d",
              "type": "basic.code",
              "data": {
                "code": "//-- module bomba_x1(input wire clk, output wire clk_1hz)\n\n//-- Bombeo de bits a 1Hz (1 pulsacion por segundo)\n\n//-- Constante para dividir y obtener una frecuencia de 2Hz\nlocalparam M = 6000000;\n\n//-- Calcular el numero de bits para almacenar M\nlocalparam N = $clog2(M);\n\n//-- Registro del divisor\nreg [N-1:0] divcounter;\n\n//-- Contador modulo M. tras M pulsos de relog vuelve a 0\nalways @(posedge clk)\n  divcounter <= (divcounter == M - 1) ? 0 : divcounter + 1;\n\n//-- Obtener la señal de 2Hz. La señal no tiene ciclo del 50%\nwire clk_2hz;\nassign clk_2hz = divcounter[N-1]; \n\n//-- Usamos un biestable T para dividir entre 2 y obtener una señal\n//-- de 1Hz y ciclo del 50%\nreg T = 0;\nalways @(posedge clk_2hz)\n  T <= ~T;\n  \n//-- Señal de salida de 1Hz y ciclo del 50%\nassign clk_1hz = T;\n  \n//endmodule\n \n\n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "clk"
                    }
                  ],
                  "out": [
                    {
                      "name": "clk_1hz"
                    }
                  ]
                }
              },
              "position": {
                "x": 192,
                "y": 24
              },
              "size": {
                "width": 592,
                "height": 320
              }
            },
            {
              "id": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
              "type": "basic.input",
              "data": {
                "name": "",
                "clock": true
              },
              "position": {
                "x": 0,
                "y": 152
              }
            },
            {
              "id": "7e07d449-6475-4839-b43e-8aead8be2aac",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 856,
                "y": 152
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "8709aff2-3586-4a6f-b6c5-d8751d3bc45d",
                "port": "clk_1hz"
              },
              "target": {
                "block": "7e07d449-6475-4839-b43e-8aead8be2aac",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
                "port": "out"
              },
              "target": {
                "block": "8709aff2-3586-4a6f-b6c5-d8751d3bc45d",
                "port": "clk"
              }
            }
          ]
        },
        "state": {
          "pan": {
            "x": 20,
            "y": 0
          },
          "zoom": 1
        }
      }
    },
    "b5f09a0668df8da316c9299ce5116364a98e20da": {
      "package": {
        "name": "Contador-bus-5",
        "version": "0.1",
        "description": "Contador de 5 bits con salida en bus",
        "author": "Juan González Gómez (Obijuan)",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22270.132%22%20height=%22146.296%22%20viewBox=%220%200%20253.2485%20137.15277%22%3E%3Cdefs%3E%3Cmarker%20orient=%22auto%22%20id=%22a%22%20overflow=%22visible%22%3E%3Cpath%20d=%22M2.308%200l-3.46%202v-4l3.46%202z%22%20fill=%22#00f%22%20fill-rule=%22evenodd%22%20stroke=%22#00f%22%20stroke-width=%22.4pt%22/%3E%3C/marker%3E%3C/defs%3E%3Cg%20transform=%22translate(-139.724%20-292.082)%22%3E%3Crect%20width=%2239.464%22%20height=%2263.929%22%20x=%22318.242%22%20y=%22329.214%22%20ry=%223.75%22%20fill=%22#666%22%20stroke=%22#000%22%20stroke-width=%222%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22340.77%22%20y=%22359.153%22%20transform=%22scale(.94516%201.05802)%22%20font-weight=%22400%22%20font-size=%2247.638%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%222%22%3E%3Ctspan%20x=%22340.77%22%20y=%22359.153%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3E0%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M319.74%20362.607h37.093%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%223%22%20stroke-linecap=%22square%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22161.09%22%20y=%22318.34%22%20font-weight=%22400%22%20font-size=%2234.561%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%3E%3Ctspan%20x=%22161.09%22%20y=%22318.34%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3EContador%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M378.373%20388.969V343.75%22%20fill=%22#00f%22%20stroke=%22#00f%22%20stroke-width=%226%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22%20marker-end=%22url(#a)%22/%3E%3Crect%20width=%2239.464%22%20height=%2263.929%22%20x=%22273.599%22%20y=%22329.214%22%20ry=%223.75%22%20fill=%22#666%22%20stroke=%22#000%22%20stroke-width=%222%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22293.536%22%20y=%22359.153%22%20transform=%22scale(.94516%201.05802)%22%20font-weight=%22400%22%20font-size=%2247.638%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%222%22%3E%3Ctspan%20x=%22293.536%22%20y=%22359.153%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3E0%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M275.097%20362.607h37.093%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%223%22%20stroke-linecap=%22square%22%20stroke-linejoin=%22round%22/%3E%3Crect%20width=%2239.464%22%20height=%2263.929%22%20x=%22229.67%22%20y=%22329.214%22%20ry=%223.75%22%20fill=%22#666%22%20stroke=%22#000%22%20stroke-width=%222%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22247.059%22%20y=%22359.153%22%20transform=%22scale(.94516%201.05802)%22%20font-weight=%22400%22%20font-size=%2247.638%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%222%22%3E%3Ctspan%20x=%22247.059%22%20y=%22359.153%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3E0%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M231.168%20362.607h37.094%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%223%22%20stroke-linecap=%22square%22%20stroke-linejoin=%22round%22/%3E%3Crect%20width=%2239.464%22%20height=%2263.929%22%20x=%22185.027%22%20y=%22329.214%22%20ry=%223.75%22%20fill=%22#666%22%20stroke=%22#000%22%20stroke-width=%222%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22199.826%22%20y=%22359.153%22%20transform=%22scale(.94516%201.05802)%22%20font-weight=%22400%22%20font-size=%2247.638%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%222%22%3E%3Ctspan%20x=%22199.826%22%20y=%22359.153%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3E0%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M186.525%20362.607h37.094%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%223%22%20stroke-linecap=%22square%22%20stroke-linejoin=%22round%22/%3E%3Crect%20width=%2239.464%22%20height=%2263.929%22%20x=%22140.724%22%20y=%22329.487%22%20ry=%223.75%22%20fill=%22#666%22%20stroke=%22#000%22%20stroke-width=%222%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22152.951%22%20y=%22359.411%22%20transform=%22scale(.94516%201.05802)%22%20font-weight=%22400%22%20font-size=%2247.638%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%222%22%3E%3Ctspan%20x=%22152.951%22%20y=%22359.411%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3E0%3C/tspan%3E%3C/text%3E%3Cpath%20d=%22M142.222%20362.88h37.093%22%20fill=%22#fff%22%20stroke=%22#000%22%20stroke-width=%223%22%20stroke-linecap=%22square%22%20stroke-linejoin=%22round%22/%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22164.303%22%20y=%22428.746%22%20font-weight=%22400%22%20font-size=%2234.561%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20fill=%22red%22%3E%3Ctspan%20x=%22164.303%22%20y=%22428.746%22%20style=%22-inkscape-font-specification:'sans-serif%20Bold'%22%20font-weight=%22700%22%3EBUS%205%20Bits%3C/tspan%3E%3C/text%3E%3C/g%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "7edff076-e332-49de-8746-97820b020068",
              "type": "basic.code",
              "data": {
                "code": "reg [4:0] counter = 0;\n\nalways @(posedge clk)\n  counter <= counter + 1;\n  \n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "clk"
                    }
                  ],
                  "out": [
                    {
                      "name": "counter",
                      "range": "[4:0]",
                      "size": 5
                    }
                  ]
                }
              },
              "position": {
                "x": 240,
                "y": 128
              },
              "size": {
                "width": 352,
                "height": 192
              }
            },
            {
              "id": "6ae99fac-1a4b-4497-8332-951c1506f887",
              "type": "basic.input",
              "data": {
                "name": "",
                "clock": true
              },
              "position": {
                "x": 88,
                "y": 192
              }
            },
            {
              "id": "2ce52369-b09a-43f5-8a5a-fbb9ce52918a",
              "type": "basic.output",
              "data": {
                "name": "d",
                "range": "[4:0]",
                "size": 5
              },
              "position": {
                "x": 712,
                "y": 192
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "6ae99fac-1a4b-4497-8332-951c1506f887",
                "port": "out"
              },
              "target": {
                "block": "7edff076-e332-49de-8746-97820b020068",
                "port": "clk"
              }
            },
            {
              "source": {
                "block": "7edff076-e332-49de-8746-97820b020068",
                "port": "counter"
              },
              "target": {
                "block": "2ce52369-b09a-43f5-8a5a-fbb9ce52918a",
                "port": "in"
              },
              "size": 5
            }
          ]
        },
        "state": {
          "pan": {
            "x": 103,
            "y": 70.5
          },
          "zoom": 1
        }
      }
    }
  }
}