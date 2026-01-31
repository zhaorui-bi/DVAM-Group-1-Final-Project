import os
import re
import base64

# 设置源文件和目标文件夹
source_file = 'occurrence_visualization.html'
output_folder = 'extracted_images'

# 创建存储文件夹
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 读取 HTML 内容
with open(source_file, 'r', encoding='utf-8') as f:
    content = f.read()

# 使用正则表达式查找所有 Base64 图片
# 查找格式如：src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..."
image_pattern = r'src="data:image/(png|jpeg|jpg);base64,([^"]+)"'
images = re.findall(image_pattern, content)

print(f"检测到 {len(images)} 张图片，正在开始提取...")

for i, (img_type, img_data) in enumerate(images):
    # 解码 Base64 字符串
    try:
        binary_data = base64.b64decode(img_data)
        file_name = f'visualization_{i + 1}.{img_type}'
        file_path = os.path.join(output_folder, file_name)

        with open(file_path, 'wb') as f:
            f.write(binary_data)

        print(f"成功保存: {file_name}")
    except Exception as e:
        print(f"处理第 {i + 1} 张图片时出错: {e}")

print(f"\n提取完成！所有图片已储存在文件夹: {output_folder}")