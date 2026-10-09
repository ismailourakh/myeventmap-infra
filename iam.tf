data "aws_iam_policy_document" "ec2_assume_role" {
  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "backend" {

  name = "${var.project_name}-backend-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.backend.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_role_policy_attachment" "ecr" {

  role = aws_iam_role.backend.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_iam_instance_profile" "backend" {

  name = "${var.project_name}-backend-profile"

  role = aws_iam_role.backend.name

}