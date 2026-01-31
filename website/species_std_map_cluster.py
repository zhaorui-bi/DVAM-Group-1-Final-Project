import colorsys
import matplotlib.cm as cm
import matplotlib.colors as mcolors
from folium.plugins import MarkerCluster, HeatMap

# 获取species_std并按数量排序
species_std_counts = df['species_std'].value_counts()
top_10_species_stds = species_std_counts.index.tolist()[:10]
species_stds = species_std_counts.index.tolist()[:10]


center_lat = df['decimalLatitude'].mean()
center_lon = df['decimalLongitude'].mean() # 斯德哥尔摩
# 生成颜色
cmap = cm.get_cmap('tab20')
species_std_colors = {}

for i, species_std in enumerate(top_10_species_stds):
    # 使用tab20的前10种颜色
    rgba = cmap(i / 20)  # 注意：除以20不是除以10
    hex_color = mcolors.to_hex(rgba)
    species_std_colors[species_std] = hex_color

# 创建瑞典地图
m = folium.Map(
    location=[center_lat, center_lon],  # 中心点
    tiles='https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png',
    attr='卫星影像图',
    zoom_start=6,  # 初始缩放级别
    control_scale=True,  # 显示比例尺
    width='100%',
)

# 瑞典的大致边界框
sweden_bounds = [[55.0, 10.8], [69.0, 24.0]]  # [西南, 东北]

# 添加矩形显示瑞典范围
folium.Rectangle(
    bounds=sweden_bounds,
    color='#FF0000',
    weight=0.001,
    fill=True,
    fill_color='#FF0000',
    fill_opacity=0.1,
    popup='瑞典范围'
).add_to(m)

cluster = MarkerCluster().add_to(m)
for _, row in df.iterrows():
    if row['species_std'] in species_std_colors:
        folium.CircleMarker(
            location=[row['decimalLatitude'], row['decimalLongitude']],
            radius=3,
            color=species_std_colors[row['species_std']],
            fill=True
        ).add_to(cluster)

legend_html = '''
<div style="
    position: fixed; 
    bottom: 50px; left: 5px; 
    width: 180px;
    background: rgba(255, 255, 255, 0.7); /* 添加透明度 */
    border: 1px solid rgba(128, 128, 128, 0.5); /* 边框也透明 */
    border-radius: 5px; 
    padding: 10px;
    font-size: 8px;
    z-index: 9999;">
    <b>species_std分布</b>
    <hr style="margin: 5px 0;">
'''

for species_std in top_10_species_stds:
    color = species_std_colors[species_std]
    count = species_std_counts[species_std]
    legend_html += f'''
    <div style="margin: 3px 0; display: flex; align-items: center;">
        <div style="width: 14px; height: 14px; background: {color}; 
                    border: 1px solid #333; margin-right: 6px;"></div>
        <span style="flex: 1; font-weight: 500;">{species_std[:18]}{'...' if len(species_std) > 18 else ''}</span>
        <span style="color: #666; font-size: 8px;">({count})</span>
    </div>
    '''

legend_html += f'''
    <hr style="margin: 8px 0 5px 0;">
    <div style="color: #666; font-size: 8px;">
        总数据点: {len(df):,}<br>
    </div>
</div>
'''

m.get_root().html.add_child(folium.Element(legend_html))
m.save('species_std_map_cluster.html')
m